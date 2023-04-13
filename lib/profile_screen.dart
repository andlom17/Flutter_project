import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet_programmation_mobile/search_page.dart';
import 'package:projet_programmation_mobile/whishlist_page.dart';
import 'like_page.dart';
import 'package:projet_programmation_mobile/info_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> games = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response = await http.get(Uri.parse(
        'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));
    final jsonResponse = jsonDecode(response.body);
    setState(() {
      games = jsonResponse['response']['ranks'];
    });
  }

  Future<Map<String, dynamic>> fetchGameDetails(String appId) async {
    final response = await http.get(Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=$appId'));
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse[appId]['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2025),
        title: const Text(
          'Accueil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset('Icones/like.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset('Icones/whishlist.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThirdRoute()),
              );
            },
          ),
        ],
      ),
      body: games.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: games.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: FutureBuilder(
                    future: fetchGameDetails(games[index]['appid'].toString()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final gameData = snapshot.data;
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F2931),
                            border: Border.all(
                              color: const Color(0xFF1F2931),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            leading: SizedBox(
                              width: 90.0,
                              height: 90.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  gameData['header_image'] != null ? '${gameData['header_image']}' : 'N/A',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              gameData['name'] != null ? '${gameData['name']}' : 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gameData['developers'][0],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  gameData['is_free'] ? 'Free' : (gameData['price_overview'] != null ? '${gameData['price_overview']['final_formatted']}' : 'N/A'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 80.0,
                              height: 80.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoPage(
                                        gameName: gameData['name'],
                                        gameBackgroundImageUrl: gameData['header_image'],
                                        gameDescription: gameData['short_description'],
                                        releaseDate: gameData['release_date']['date'],
                                        appId: games[index]['appid'].toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset('Icones/plus.png', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
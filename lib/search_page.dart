import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'info_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _searchResults = [];

  Future<void> _search() async {
    String query = _searchController.text.trim();

    if (query.isEmpty) return;

    String url = "https://steamcommunity.com/actions/SearchApps/$query";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<dynamic> results = data;
        List<int> appIds = results.map((result) => int.parse(result["appid"])).toList();
        setState(() {
          _searchResults = appIds;
        });
      } else {
        // handle error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to search for games. Please try again later."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      // handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Failed to search for games. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2025),
        title: const Text("Recherche",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        )
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: "Enter game name",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _search,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF636AF6),
            ),
            child: const Text("Search"),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: fetchGameDetails(_searchResults[index].toString()),
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
                                      appId: _searchResults[index].toString(),
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
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 18),
            ),
          ),
        ],
      ),
    );
  }
}
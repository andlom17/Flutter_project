import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text('Ma liste de souhaits',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF1A2025),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'Icones/empty_whishlist.svg',
                  height: 150,
                  width: 150,
                ),
                const Text('\n\n Vous n \'avez pas encore liké de contenu. \n Cliquez sur l\'étoile pour en rajouter.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                      height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )
              ]
          )

      ),
    );
  }
}
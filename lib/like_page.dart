import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text('Mes likes',
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
                  'Icones/empty_likes.svg',
                  height: 150,
                  width: 150,
                ),
                const Text('\n\n Vous n \'avez pas encore liké de contenu. \n Cliquez sur le coeur pour en rajouter.',
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
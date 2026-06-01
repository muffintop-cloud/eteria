// renders the characters appearance as stacked png layers

import 'package:flutter/material.dart';
import 'package:eteria/models/character.dart';

class CharacterDisplay extends StatelessWidget {
  final Character character;
  const CharacterDisplay({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand, // makes every layer fill the parent container so BoxFit.contain scales them all to the same size
      children: [
        Image.asset(
          character.bodyAssetPath,
          fit: BoxFit.contain,
        ),
        Image.asset(
          character.hairAssetPath,
          fit: BoxFit.contain,
        ),
        Image.asset(
          character.eyesAssetPath,
          fit: BoxFit.contain,
        ),
        Image.asset(
          character.outfitAssetPath,
          fit: BoxFit.contain,
        ),

      ],
    );
  }
}
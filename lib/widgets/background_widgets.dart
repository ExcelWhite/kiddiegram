import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {

  final backgroundImageUrl;
  
  const BackgroundWidget({super.key, required this.backgroundImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(backgroundImageUrl),
        fit: BoxFit.cover,
      ),
    ),
  );
  }
}
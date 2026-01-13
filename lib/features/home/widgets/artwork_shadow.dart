import 'package:flutter/material.dart';

class ArtworkShadow extends StatelessWidget {
  final List<Color> colors;
  final List<double> stops;

  const ArtworkShadow({super.key, required this.colors, required this.stops});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: colors,
            stops: stops
          ),
        ),
      ),
    );
  }
}

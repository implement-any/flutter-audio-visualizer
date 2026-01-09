import 'package:flutter/material.dart';

class ArtworkCircle extends StatelessWidget {
  const ArtworkCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircleAvatar(
        backgroundColor: Colors.black,
      ),
    );
  }
}

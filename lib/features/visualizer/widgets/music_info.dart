import 'package:flutter/material.dart';

class MusicInfo extends StatelessWidget {
  final String title;
  final String subTitle;

  const MusicInfo({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          subTitle,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ],
    );
  }
}

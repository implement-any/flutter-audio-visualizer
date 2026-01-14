import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class CustomDivider extends StatelessWidget {
  final double size;

  const CustomDivider({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: BaseColor.white),
      ),
    );
  }
}

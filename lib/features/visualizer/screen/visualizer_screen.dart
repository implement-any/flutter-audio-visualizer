import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/ui/audio_status.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/background_blur.dart';

class VisualizerScreen extends StatefulWidget {
  final Music music;

  const VisualizerScreen({super.key, required this.music});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  late final AudioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AudioController();
    _init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _controller.setAudio(widget.music.audioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColor.black,
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundBlur(blurHash: widget.music.blurHash),
            AudioStatus(music: widget.music, controller: _controller),
          ],
        ),
      ),
    );
  }
}

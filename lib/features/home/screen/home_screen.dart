import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';
import 'package:flutter_audio_visualizer/features/home/ui/music_list.dart';
import 'package:flutter_audio_visualizer/features/home/ui/top_artwork.dart';
import 'package:flutter_audio_visualizer/features/home/provider/music_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(musicProvider);

    return Scaffold(
      backgroundColor: BaseColor.black,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            TopArtwork(),
            asyncValue.when(
              data: (musicList) {
                return Expanded(child: MusicList(musicList: musicList));
              },
              error: (err, stack) {
                return const Expanded(child: Text("Error!!"));
              },
              loading: () {
                return const Expanded(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

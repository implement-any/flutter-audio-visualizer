import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/shared/widgets/center_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';
import 'package:flutter_audio_visualizer/shared/widgets/custom_divider.dart';
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
            Expanded(
              child: asyncValue.when(
                data: (musicList) => MusicList(musicList: musicList),
                error: (err, stack) {
                  return const CenterText(text: "음원 목록 불러오기를 실패하였습니다.");
                },
                loading: () => const CustomDivider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

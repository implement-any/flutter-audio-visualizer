import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/shared/widgets/cover_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_audio_visualizer/core/router/custom_router.dart';
import 'package:flutter_audio_visualizer/features/home/widgets/music_meta.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';

class MusicList extends StatelessWidget {
  final List<Music> musicList;

  const MusicList({super.key, required this.musicList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: musicList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          context.push(Paths.visualizer, extra: musicList[index]);
        },
        child: Row(
          spacing: 8,
          children: [
            CoverImage(
              size: 50,
              blurHash: musicList[index].blurHash,
              imageUrl: musicList[index].cover,
            ),
            MusicMeta(
              title: musicList[index].title,
              subTitle: musicList[index].subTitle,
            ),
          ],
        ),
      ),
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
    );
  }
}

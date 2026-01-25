import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/shell/appbar_inset.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';
import 'package:flutter_audio_visualizer/features/home/provider/music_provider.dart';
import 'package:flutter_audio_visualizer/features/home/ui/music_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    setAppBar();
  }

  void setAppBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const config = AppBarConfig(title: "Visualizer");
      ref.read(appBarConfigProvider.notifier).state = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicList = ref.watch(musicProvider);

    return AppbarInset(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: const Text("림버스 컴퍼니 보스 테마 곡"),
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child: MusicList(musicList: musicList),
          ),
        ],
      ),
    );
  }
}

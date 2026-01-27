import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/home/ui/home_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';

import 'package:flutter_audio_visualizer/features/home/provider/music_provider.dart';
import 'package:flutter_audio_visualizer/features/home/ui/music_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _setAppBar() {
    ref.read(appBarOverrideProvider.notifier).state = AppBarOverride(
      title: "Limbus Company OST",
      centerTitle: false,
      actions: const [], // 필요하면 넣기
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setAppBar());
  }

  @override
  Widget build(BuildContext context) {
    final musicList = ref.watch(musicProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTitle(),
        MusicList(musicList: musicList),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';

class ShellScaffold extends ConsumerWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appBarConfigProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: config == null
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              title: Text(config.title),
              titleTextStyle: TextStyle(fontSize: 20),
              titleSpacing: 15,
              elevation: 0,
              centerTitle: config.centerTitle,
              actions: config.actions,
              automaticallyImplyLeading: config.showBack,
            ),
      body: child
    );
  }
}

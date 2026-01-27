import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';

class ShellScaffold extends ConsumerWidget {
  final GlobalKey<NavigatorState> shellNavigationKey;
  final Widget child;

  const ShellScaffold({
    super.key,
    required this.shellNavigationKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(appBarOverrideProvider);

    final canPop = shellNavigationKey.currentState?.canPop() ?? false;

    final title = override?.title ?? "Limbus Company OST";
    final centerTitle = override?.centerTitle ?? false;
    final actions = override?.actions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title),
        titleTextStyle: TextStyle(fontSize: 20),
        titleSpacing: 15,
        elevation: 0,
        centerTitle: centerTitle,
        actions: actions,
        leading: canPop
            ? IconButton(
                onPressed: () => shellNavigationKey.currentState?.maybePop(),
                icon: const BackButtonIcon(),
              )
            : null,
      ),
      body: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class BackgroundConfig {
  final String hash;
  final int rev;

  const BackgroundConfig({
    required this.hash,
    required this.rev,
  });

  BackgroundConfig copyWith({String? hash, int? rev}) {
    return BackgroundConfig(
      hash: hash ?? this.hash,
      rev: rev ?? this.rev,
    );
  }

  static const empty = BackgroundConfig(hash: '', rev: 0);
}

class AppBarOverride {
  final String? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  const AppBarOverride({
    this.title,
    this.centerTitle,
    this.actions,
  });
}

final backgroundConfigProvider = StateProvider<BackgroundConfig>((ref) {
  return BackgroundConfig.empty;
});

final appBarOverrideProvider = StateProvider<AppBarOverride?>((ref) => null);
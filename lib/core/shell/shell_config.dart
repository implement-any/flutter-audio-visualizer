import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class AppBarConfig {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showBack;

  const AppBarConfig({
    required this.title,
    this.centerTitle = false,
    this.actions,
    this.showBack = false,
  });
}

final appBarConfigProvider = StateProvider<AppBarConfig?>((ref) {
  return null;
});

final backgroundConfigProvider = StateProvider<String>((ref) {
  return "";
});

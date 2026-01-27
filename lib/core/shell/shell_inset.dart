import 'package:flutter/material.dart';

class AppbarInset extends StatelessWidget {
  final Widget child;

  const AppbarInset({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: child,
    );
  }
}

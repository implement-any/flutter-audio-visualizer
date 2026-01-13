import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class TopArtwork extends StatelessWidget {
  const TopArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: BlurHash(
        hash: "LAA0d.01pMo#%Dfm9#xU00?u9ExV",
        image:
            "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1973530/capsule_616x353.jpg?t=1767762486",
        imageFit: BoxFit.cover,
      ),
    );
  }
}

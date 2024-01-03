import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../edit.dart';

class Panel1Widget extends StatelessWidget {
  String? mainImageBase64;
  String? babyImageBase64;

  Panel1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Panel 1",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ImageInput(
            height: 300,
            aspectRatio: 3 / 4,
            prompt: "Ein Bild von dir (Format: 3:4)",
            base64ImageSelected: (base64Img) => mainImageBase64 = base64Img,
          ),
          ImageInput(
            height: 300,
            aspectRatio: 3 / 4,
            prompt:
                "Ein Bild von dir aus deiner Kindheit, z.B. von deiner Einschulung (Format: 3:4)",
            base64ImageSelected: (base64Img) => babyImageBase64 = base64Img,
          ),
        ],
      ),
    );
  }

  String? fillPreview(PreviewModel preview) {
    if (mainImageBase64 == null) return "Du hast kein Bild von dir ausgewählt";
    preview.hauptBildBase64 = mainImageBase64;
    if (babyImageBase64 == null) {
      return "Es fehlt noch ein Bild aus deiner Kindheit";
    }
    preview.babyBildBase64 = babyImageBase64;
    return null;
  }
}

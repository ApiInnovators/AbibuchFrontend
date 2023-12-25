import 'package:flutter/material.dart';
import 'package:hgv_abibuch/api/api.dart';

import '../edit.dart';

class Panel2Widget extends StatelessWidget {
  final inputs = List<Input>.empty(growable: true);

  final List<String?> freundeBilderBase64 = [null, null, null, null];
  final imgInputs = List<ImageInput>.empty(growable: true);

  static const maxZitatLength = 125;

  Panel2Widget({super.key}) {
    inputs.addAll([
      Input(
        prompt: const Text("Name von Freund 1"),
        hintText: 'Max',
        maxLength: 16,
      ),
      Input(
        prompt: const Text("Zitat von Freund 1"),
        hintText: 'Er/Sie ist immer für eine Party zu haben!',
        maxLength: maxZitatLength,
      ),
      Input(
        prompt: const Text("Name von Freund 2"),
        hintText: 'Anna',
        maxLength: 16,
      ),
      Input(
        prompt: const Text("Zitat von Freund 2"),
        hintText:
            'Wenn er/sie sich etwas in den Kopf gesetzt hat, kann es niemand aufhalten',
        maxLength: maxZitatLength,
      ),
      Input(
        prompt: const Text("Name von Freund 3"),
        hintText: 'Tom',
        maxLength: 16,
      ),
      Input(
        prompt: const Text("Zitat von Freund 3"),
        hintText: 'Es gibt niemand besseren auf der Welt.',
        maxLength: maxZitatLength,
      ),
      Input(
        prompt: const Text("Name von Freund 4"),
        hintText: 'Lisa',
        maxLength: 16,
      ),
      Input(
        prompt: const Text("Zitat von Freund 4"),
        hintText: 'Chaotic Neutral',
        maxLength: maxZitatLength,
      ),
    ]);
    imgInputs.addAll(
      List.generate(
        4,
        (i) => ImageInput(
          height: 100,
          aspectRatio: 1 / 1,
          prompt: "Bild von Freund ${i + 1} (Format: 1:1)",
          base64ImageSelected: (base64Img) =>
              freundeBilderBase64[i] = base64Img,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Panel 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          for (int i = 0; i < inputs.length; i += 2) ...[
            Card(
              color: const Color.fromARGB(255, 64, 102, 134),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Freund ${i / 2 + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  imgInputs[i ~/ 2],
                  const SizedBox(height: 10),
                  inputs[i],
                  inputs[i + 1],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? fillPreview(PreviewModel preview) {
    List<String> freunde = List.empty(growable: true);
    List<String> zitate = List.empty(growable: true);
    List<String> freundeBilder = List.empty(growable: true);

    for (int i = 0; i < inputs.length; i += 2) {
      freunde.add(inputs[i].getInput());
      zitate.add(inputs[i + 1].getInput());

      final img = freundeBilderBase64[i ~/ 2];
      if (img == null) return "Kein Bild von Freund ${i ~/ 2 + 1} vorhanden";

      freundeBilder.add(img);
    }

    preview.freundeBilderBase64 = freundeBilder;
    preview.zitate = zitate;
    preview.freunde = freunde;

    return null;
  }
}

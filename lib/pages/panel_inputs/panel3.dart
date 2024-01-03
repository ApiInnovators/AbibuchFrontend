import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../edit.dart';

class Panel3Widget extends StatelessWidget {
  final inputs = List<Input>.empty(growable: true);

  static const maxTextLength = 42;

  Panel3Widget({super.key}) {
    inputs.addAll([
      Input(
        prompt: const Text("Lieblingslehrer"),
        hintText: "Herr X",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Lieblingsfächer"),
        hintText: "Mathe, Deutsch und Englisch",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Lieblingsbeschäftigung"),
        hintText: "Essen",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Pläne nach dem Abi"),
        hintText: "Astrobotanik studieren",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Größter außerschulischer Erfolg"),
        hintText: "Meine Geburt",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Krassestes Unterrichtserlebnis"),
        hintText: "Toilette ist explodiert",
        maxLength: maxTextLength,
      ),
      Input(
        prompt: const Text("Was mich einzigartig macht"),
        hintText: "Niemand kann bessere Kekse backen als Ich!",
        maxLength: maxTextLength,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Panel 3",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          for (final input in inputs) input,
        ],
      ),
    );
  }

  void fillPreview(PreviewModel preview) {
    preview.lieblingslehrer = inputs[0].getInput();
    preview.lieblingsfaecher = inputs[1].getInput();
    preview.lieblingsbeschaeftigung = inputs[2].getInput();
    preview.plaene = inputs[3].getInput();
    preview.groessterErfolg = inputs[4].getInput();
    preview.krassestesErlebnis = inputs[5].getInput();
    preview.einzigartigkeit = inputs[6].getInput();
  }
}

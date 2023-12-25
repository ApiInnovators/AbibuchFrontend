import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../edit.dart';

class Panel4Widget extends StatelessWidget {

  late final Input textVonFreundenInput;

  Panel4Widget({super.key}) {
    textVonFreundenInput = Input(
      prompt: const Text("Text von Freunden"),
      hintText:
          "Er/Sie ist manchmal ein wenig tollpatschig, aber genau das macht ihn/sie auf eine liebenswerte Weise einzigartig...",
      maxLength: 36 * 28,
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
              "Panel 4",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          textVonFreundenInput,
        ],
      ),
    );
  }

  void fillPreview(PreviewModel preview) {
    preview.textVonFreunden = textVonFreundenInput.getInput();
  }
}

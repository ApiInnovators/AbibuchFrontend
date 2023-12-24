import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../edit.dart';

class Panel4Widget extends StatelessWidget {
  final LoginModel login;
  final PreviewModel? lastData;

  late final Input textVonFreundenInput;

  Panel4Widget({super.key, required this.login, required this.lastData}) {
    final firstName = login.name.split(" ")[0];

    textVonFreundenInput = Input(
      prompt: const Text("Text von Freunden"),
      hintText:
          "$firstName ist manchmal ein wenig tollpatschig, aber genau das macht ihn auf eine liebenswerte Weise einzigartig...",
      maxLength: 750,
      initialValue: lastData?.textVonFreunden,
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

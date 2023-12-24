import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../main.dart';
import '../edit.dart';

class GenerellPanelWidget extends StatelessWidget {
  final PreviewModel? lastData;
  final LoginModel login;
  Input? birthdateInput;

  GenerellPanelWidget({super.key, required this.lastData, required this.login});

  @override
  Widget build(BuildContext context) {
    birthdateInput ??= Input(
      prompt: const Text("Dein Geburtsdatum"),
      hintText: "06.09.2006",
      maxLength: 10,
      initialValue: lastData?.geburtsDatum,
      suffix: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2010),
            );
            if (selectedDate == null) return;
            birthdateInput!.controller.text = dateFormat.format(selectedDate);
          }),
      additionalValidator: (value) {
        if (dateFormat.tryParse(value) == null) return "Ungültiges Datum";
        return null;
      },
    );

    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Über dich",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(title: Text("Name: ${login.name}")),
          const SizedBox(height: 10),
          birthdateInput!,
        ],
      ),
    );
  }

  String? fillPreview(PreviewModel preview) {
    if (dateFormat.tryParse(birthdateInput!.getInput()) == null) {
      return "Ungültiges Geburtsdatumformat";
    }
    preview.geburtsDatum = birthdateInput!.getInput();
    return null;
  }
}

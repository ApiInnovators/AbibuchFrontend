import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hgv_abibuch/pages/preview.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';

class EditPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String userName;

  EditPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final inputWidget = InputWidget(formKey: _formKey, userName: userName);
    return Scaffold(
      appBar: AppBar(title: const Text("Bearbeiten")),
      body: Column(
        children: [
          Expanded(child: inputWidget),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate() && !kDebugMode) return;

              final gen = inputWidget.generateData();

              if (gen.$1 == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(gen.$2)));
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewPage(
                    inputData: gen.$1!,
                  ),
                ),
              );
            },
            child: const Text("Vorschau"),
          ),
        ],
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  final panel2inputs = [
    Input(
        prompt: const Text("Name von Freund 1"),
        hintText: 'Max',
        maxLength: 16),
    Input(
        prompt: const Text("Zitat von Freund 1"),
        hintText: 'Immer für jede Party zu haben',
        maxLength: 90),
    Input(
        prompt: const Text("Name von Freund 2"),
        hintText: 'Anna',
        maxLength: 16),
    Input(
        prompt: const Text("Zitat von Freund 2"),
        hintText: 'Die Legende',
        maxLength: 90),
    Input(
        prompt: const Text("Name von Freund 3"),
        hintText: 'Tom',
        maxLength: 16),
    Input(
        prompt: const Text("Zitat von Freund 3"),
        hintText: 'Es gibt niemand besseren auf der Welt',
        maxLength: 90),
    Input(
        prompt: const Text("Name von Freund 4"),
        hintText: 'Lisa',
        maxLength: 16),
    Input(
        prompt: const Text("Zitat von Freund 4"),
        hintText: 'Chaotic Neutral',
        maxLength: 90),
  ];

  final panel2ImgInputs = [
    ImageInput(
      height: 100,
      aspectRatio: 1 / 1,
      prompt: "Foto von Freund 1 auswählen",
    ),
    ImageInput(
      height: 100,
      aspectRatio: 1 / 1,
      prompt: "Foto von Freund 2 auswählen",
    ),
    ImageInput(
      height: 100,
      aspectRatio: 1 / 1,
      prompt: "Foto von Freund 3 auswählen",
    ),
    ImageInput(
      height: 100,
      aspectRatio: 1 / 1,
      prompt: "Foto von Freund 4 auswählen",
    ),
  ];

  final panel3Inputs = [
    Input(
      prompt: const Text("Lieblingslehrer"),
      hintText: "Herr X",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Lieblingsfächer"),
      hintText: "Mathe, Deutsch und Englisch",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Lieblingsbeschäftigung"),
      hintText: "Essen",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Pläne nach dem Abi"),
      hintText: "Astrobotanik studieren",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Größter außerschulischer Erfolg"),
      hintText: "Meine Geburt",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Krassestes Unterrichtserlebnis"),
      hintText: "Toilette ist explodiert",
      maxLength: 26,
    ),
    Input(
      prompt: const Text("Was mich einzigartig macht"),
      hintText: "Niemand kann bessere Kekse backen als Ich!",
      maxLength: 78,
    ),
  ];

  Input? birthdateInput;
  final ImageInput mainImageInput = ImageInput(
    height: 300,
    aspectRatio: 3 / 4,
    prompt: "Ein Bild von dir",
  );

  final String userName;

  late final Input textVonFreundenInput;

  InputWidget({super.key, required this.formKey, required this.userName}) {
    final firstName = userName.split(" ")[0];

    textVonFreundenInput = Input(
      prompt: const Text("Text von Freunden"),
      hintText:
          "$firstName ist manchmal ein wenig tollpatschig, aber genau das macht ihn auf eine liebenswerte Weise einzigartig...",
      maxLength: 750,
    );
  }

  @override
  Widget build(BuildContext context) {
    birthdateInput ??= Input(
      prompt: const Text("Dein Geburtsdatum"),
      hintText: "06.09.2006",
      maxLength: 10,
      suffix: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2010),
            );
            if (selectedDate == null) return;
            birthdateInput!._controller.text = dateFormat.format(selectedDate);
          }),
      additionalValidator: (value) {
        if (dateFormat.tryParse(value) == null) return "Ungültiges Datum";
        return null;
      },
    );

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Über dich"),
                    titleTextStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  mainImageInput,
                  const SizedBox(height: 10),
                  birthdateInput!,
                ],
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(children: [
                const ListTile(
                  title: Text("Panel 2"),
                  titleTextStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                for (int i = 0; i < panel2inputs.length; i += 2) ...[
                  Card(
                    color: const Color.fromARGB(255, 178, 205, 238),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Freund ${i / 2 + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        panel2ImgInputs[i ~/ 2],
                        const SizedBox(height: 10),
                        panel2inputs[i],
                        panel2inputs[i + 1],
                      ],
                    ),
                  ),
                ],
              ]),
            ),
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Panel 3"),
                    titleTextStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  for (final input in panel3Inputs) input,
                ],
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Panel 4"),
                    titleTextStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  textVonFreundenInput,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (PreviewModel? data, String error) generateData() {
    List<String> freunde = List.empty(growable: true);
    List<String> zitate = List.empty(growable: true);
    List<String> freundeBilder = List.empty(growable: true);

    for (int i = 0; i < panel2inputs.length; i += 2) {
      freunde.add(panel2inputs[i].getInput());
      zitate.add(panel2inputs[i + 1].getInput());
      final img = panel2ImgInputs[i ~/ 2].state.getBase64();
      if (img == null) {
        return (null, "Kein Bild von Freund ${i ~/ 2 + 1} vorhanden");
      }
      freundeBilder.add(img);
    }

    final birthdate = dateFormat.parse(birthdateInput!.getInput());
    final mainImg = mainImageInput.state.getBase64();

    if (mainImg == null) {
      return (null, "Kein Bild von dir vorhanden");
    }

    return (
      PreviewModel(
        name: userName,
        geburtsDatum: birthdate,
        freunde: freunde,
        zitate: zitate,
        lieblingslehrer: panel3Inputs[0].getInput(),
        lieblingsfaecher: panel3Inputs[1].getInput(),
        lieblingsbeschaeftigung: panel3Inputs[2].getInput(),
        plaene: panel3Inputs[3].getInput(),
        groessterErfolg: panel3Inputs[4].getInput(),
        krassestesErlebnis: panel3Inputs[5].getInput(),
        einzigartigkeit: panel3Inputs[6].getInput(),
        textVonFreunden: textVonFreundenInput.getInput(),
        freundeBilderBase64: freundeBilder,
        hauptBildBase64: mainImg,
      ),
      ""
    );
  }
}

class Input extends StatelessWidget {
  final Widget prompt;
  final String hintText;
  final int maxLength;
  final _controller = TextEditingController();
  final Widget? suffix;
  final String? Function(String value)? additionalValidator;

  Input({
    super.key,
    required this.prompt,
    required this.hintText,
    required this.maxLength,
    this.suffix,
    this.additionalValidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: prompt,
        hintText: hintText,
        suffixIcon: suffix,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Bitte gib hier etwas ein";
        }
        if (additionalValidator != null) {
          return additionalValidator!(value);
        }
        return null;
      },
    );
  }

  String getInput() => _controller.text;
}

class ImageInput extends StatefulWidget {
  final String prompt;
  final double height;
  final double aspectRatio;
  late ImageInputState state;

  ImageInput({
    super.key,
    required this.height,
    required this.aspectRatio,
    required this.prompt,
  });

  @override
  State<ImageInput> createState() {
    state = ImageInputState();
    return state;
  }
}

class ImageInputState extends State<ImageInput> {
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return ListTile(
        title: Text(widget.prompt),
        trailing: ElevatedButton(
          onPressed: () async {
            image = await ImagePickerWeb.getImageAsBytes();
            if (mounted) setState(() {});
          },
          child: const Text("Bild auswählen"),
        ),
      );
    }

    Image img = Image.memory(
      image!,
      height: widget.height,
      width: widget.aspectRatio * widget.height,
      fit: BoxFit.fill,
    );

    return Column(
      children: [
        Text(widget.prompt),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: img,
        ),
        ElevatedButton(
          onPressed: () async {
            image = await ImagePickerWeb.getImageAsBytes();
            if (mounted) setState(() {});
          },
          child: const Text("Anderes Bild auswählen"),
        ),
      ],
    );
  }

  String? getBase64() {
    if (image == null) return null;
    return base64Encode(image!);
  }
}

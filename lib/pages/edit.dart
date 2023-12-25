import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hgv_abibuch/pages/panel_inputs/generell.dart';
import 'package:hgv_abibuch/pages/panel_inputs/panel1.dart';
import 'package:hgv_abibuch/pages/panel_inputs/panel2.dart';
import 'package:hgv_abibuch/pages/panel_inputs/panel3.dart';
import 'package:hgv_abibuch/pages/panel_inputs/panel4.dart';
import 'package:hgv_abibuch/pages/preview.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../api/api.dart';

class EditPage extends StatelessWidget {
  final LoginModel login;
  final PreviewModel? lastSubmittedData;

  const EditPage({
    super.key,
    required this.login,
    required this.lastSubmittedData,
  });

  @override
  Widget build(BuildContext context) {
    final inputWidget = InputWidget(
      login: login,
      lastSubmittedData: lastSubmittedData,
      onPreview: (PreviewModel data) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(inputData: data),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Bearbeiten")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            inputWidget,
            const ListTile(
              leading: Icon(Icons.copyright),
              title: Text("Finn Drünert 2023"),
            ),
          ],
        ),
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  final LoginModel login;
  final PreviewModel? lastSubmittedData;

  final void Function(PreviewModel data) onPreview;

  const InputWidget({
    super.key,
    required this.login,
    required this.lastSubmittedData,
    required this.onPreview,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final GenerellPanelWidget generellInput = GenerellPanelWidget(
    lastData: widget.lastSubmittedData,
    login: widget.login,
  );
  late final Panel1Widget panel1Input =
      Panel1Widget(lastData: widget.lastSubmittedData);
  late final Panel2Widget panel2Input = Panel2Widget(
    lastData: widget.lastSubmittedData,
    login: widget.login,
  );
  late final Panel3Widget panel3Input =
      Panel3Widget(lastData: widget.lastSubmittedData);
  late final Panel4Widget panel4Input = Panel4Widget(
    login: widget.login,
    lastData: widget.lastSubmittedData,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          generellInput,
          panel1Input,
          panel2Input,
          panel3Input,
          panel4Input,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate() && !kDebugMode) {
                    return;
                  }

                  final gen = generateData();

                  if (gen.$1 == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(gen.$2)));
                    return;
                  }

                  widget.onPreview(gen.$1!);
                },
                child: const Text("Vorschau"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (PreviewModel? data, String error) generateData() {
    final preview = PreviewModel(widget.login);
    String? error;
    error ??= generellInput.fillPreview(preview);
    error ??= panel1Input.fillPreview(preview);
    error ??= panel2Input.fillPreview(preview);
    panel3Input.fillPreview(preview);
    panel4Input.fillPreview(preview);
    if (error != null) return (null, error);
    return (preview, "");
  }
}

class Input extends StatelessWidget {
  final Widget prompt;
  final String hintText;
  final int maxLength;
  final controller = TextEditingController();
  final Widget? suffix;
  final String? Function(String value)? additionalValidator;
  final String? initialValue;

  Input({
    super.key,
    required this.prompt,
    required this.hintText,
    required this.maxLength,
    this.suffix,
    this.additionalValidator,
    this.initialValue,
  }) {
    if (initialValue != null) controller.text = initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: controller,
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
      ),
    );
  }

  String getInput() => controller.text;
}

class ImageInput extends StatefulWidget {
  final String prompt;
  final double height;
  final double aspectRatio;
  final void Function(String base64Img) base64ImageSelected;
  final String? initialImage;

  const ImageInput({
    super.key,
    required this.height,
    required this.aspectRatio,
    required this.prompt,
    required this.base64ImageSelected,
    this.initialImage,
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      image = base64Decode(widget.initialImage!);
      widget.base64ImageSelected(base64Encode(image!));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Text(widget.prompt),
            trailing: ElevatedButton(
              onPressed: () async {
                image = await ImagePickerWeb.getImageAsBytes();
                if (image == null) return;
                widget.base64ImageSelected(base64Encode(image!));
                if (mounted) setState(() {});
              },
              child: const Text("Bild auswählen"),
            ),
          ),
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
            if (image == null) return;
            widget.base64ImageSelected(base64Encode(image!));
            if (mounted) setState(() {});
          },
          child: const Text("Anderes Bild auswählen"),
        ),
      ],
    );
  }
}

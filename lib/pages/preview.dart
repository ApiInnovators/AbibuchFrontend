import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hgv_abibuch/api/api.dart';

class PreviewPage extends StatelessWidget {
  final PreviewModel inputData;

  const PreviewPage({super.key, required this.inputData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vorschau")),
      body: FutureBuilder(
        future: Api.preview(inputData),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Lade Vorschau..."),
                  SizedBox(width: 10),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          if (snapshot.hasError) return const Text("Error");

          if (snapshot.requireData.statusCode != 200) {
            return Text(
                "Error: ${snapshot.requireData.statusCode}\n${snapshot.requireData.body}");
          }

          final imgData = snapshot.requireData.bodyBytes;

          return Column(
            children: [
              Expanded(child: Image.memory(imgData)),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => download(
                        imgData,
                        "Abibuchseite von ${inputData.name}.png",
                        "image/png",
                      ),
                      icon: const Icon(Icons.download),
                      label: const Text("Als Bild herunterladen"),
                    ),
                  ],
                ),
              ),
              const ListTile(
                leading: Icon(Icons.copyright),
                title: Text("Finn Drünert 2023"),
              ),
            ],
          );
        },
      ),
    );
  }
}

void download(List<int> bytes, String downloadName, String mimeType) {
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor = AnchorElement(href: 'data:$mimeType;base64,$base64')
    ..target = 'blank';
  anchor.download = downloadName;
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}

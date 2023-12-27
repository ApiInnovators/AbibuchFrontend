import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hgv_abibuch/api/api.dart';

class PreviewPage extends StatefulWidget {
  final PreviewModel inputData;

  const PreviewPage({super.key, required this.inputData});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late Future<Response> previewData;
  double sendProgress = 0;
  double receiveProgress = 0;

  @override
  void initState() {
    super.initState();
    previewData = Api.preview(
      widget.inputData,
      onReceiveProgress: (count, total) {
        setState(() => receiveProgress = count / total);
      },
      onSendProgress: (count, total) {
        setState(() => sendProgress = count / total);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vorschau")),
      body: FutureBuilder(
        future: previewData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            double totalProgress = (sendProgress + receiveProgress) / 2;
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Lade Vorschau..."),
                  const SizedBox(width: 10),
                  CircularProgressIndicator(
                    value: totalProgress == 0 ? null : totalProgress,
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) return const Text("Error");

          if (snapshot.requireData.statusCode != 200) {
            return Center(
              child: Text(
                "Error: ${snapshot.requireData.statusCode}\n${snapshot.requireData.data}",
              ),
            );
          }

          final imgData = snapshot.requireData.data;

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
                        "Abibuchseite von ${widget.inputData.name}.png",
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

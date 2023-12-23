import 'package:flutter/material.dart';
import 'package:hgv_abibuch/api/api.dart';

class PreviewPage extends StatelessWidget {
  final PreviewModel inputData;

  const PreviewPage({
    super.key,
    required this.inputData,
  });

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

          return Center(child: Image.memory(snapshot.requireData.bodyBytes));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hgv_abibuch/pages/edit.dart';
import 'package:intl/intl.dart';

final DateFormat dateFormat = DateFormat("dd.MM.yy");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abibuch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const EditPage(),
    );
  }
}

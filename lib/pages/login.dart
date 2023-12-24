import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgv_abibuch/api/api.dart';

import 'edit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoggingIn = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Name"),
                  hintText: "Max Musterman",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Bitte gib einen Wert ein";
                  }
                  return null;
                },
                autofillHints: const [AutofillHints.username],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text("Passwort"),
                  hintText: "Passwort123",
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Bitte gib einen Wert ein";
                  }
                  return null;
                },
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoggingIn ? null : loginPressed,
                child: isLoggingIn
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoggingIn = true);
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final login = LoginModel(name: name, password: password);

    final resp = await Api.login(login);

    if (resp.statusCode == 200 && mounted) {
      final decoded = jsonDecode(resp.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(
            login: login,
            lastSubmittedData: PreviewModel.fromJson(decoded),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fehler ${resp.statusCode}: ${jsonDecode(resp.body)["detail"]}',
          ),
        ),
      );
    }

    setState(() => isLoggingIn = false);
  }
}

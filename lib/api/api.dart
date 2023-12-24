import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';


class Api {
  static final client = Client();
  static const baseUrl = "https://abibuch.apiinnovators.de";

  static Future<Response> _handleRequest(BaseRequest request) async {
    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });
    try {
      final baseResp =
          await client.send(request).timeout(const Duration(seconds: 10));
      return Response.fromStream(baseResp);
    } on SocketException {
      return Response("Error", 499);
    } on TimeoutException {
      return Response("Timeout", HttpStatus.requestTimeout);
    }
  }

  static Future<Response> login(String name, String password) {
    final req = Request("POST", Uri.parse("$baseUrl/login"));
    req.body = jsonEncode({"name": name, "password": password});
    return _handleRequest(req);
  }

  static Future<Response> preview(PreviewModel data) async {
    final req = Request("POST", Uri.parse("$baseUrl/preview"));
    req.body = jsonEncode(data.toJson());
    return _handleRequest(req);
  }
}

class PreviewModel {
  final String name;
  final String hauptBildBase64;
  final DateTime geburtsDatum;
  final List<String> freunde;
  final List<String> freundeBilderBase64;
  final List<String> zitate;
  final String lieblingslehrer;
  final String lieblingsfaecher;
  final String lieblingsbeschaeftigung;
  final String plaene;
  final String groessterErfolg;
  final String krassestesErlebnis;
  final String einzigartigkeit;
  final String textVonFreunden;

  PreviewModel({
    required this.name,
    required this.geburtsDatum,
    required this.freunde,
    required this.zitate,
    required this.lieblingslehrer,
    required this.lieblingsfaecher,
    required this.lieblingsbeschaeftigung,
    required this.plaene,
    required this.groessterErfolg,
    required this.krassestesErlebnis,
    required this.einzigartigkeit,
    required this.textVonFreunden,
    required this.freundeBilderBase64,
    required this.hauptBildBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'geburts_datum': geburtsDatum.millisecondsSinceEpoch,
      'freunde': freunde,
      'zitate': zitate,
      'lieblingslehrer': lieblingslehrer,
      'lieblingsfaecher': lieblingsfaecher,
      'lieblingsbeschaeftigung': lieblingsbeschaeftigung,
      'plaene': plaene,
      'groesster_erfolg': groessterErfolg,
      'krassestes_erlebnis': krassestesErlebnis,
      'einzigartigkeit': einzigartigkeit,
      'text_von_freunden': textVonFreunden,
      'bild_base64': hauptBildBase64,
      'freunde_bilder_base64': freundeBilderBase64,
    };
  }
}

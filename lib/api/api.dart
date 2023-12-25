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
          await client.send(request).timeout(const Duration(seconds: 60));
      return Response.fromStream(baseResp);
    } on SocketException {
      return Response("Error", 499);
    } on TimeoutException {
      return Response("Timeout", HttpStatus.requestTimeout);
    }
  }

  static Future<Response> preview(PreviewModel data) async {
    final req = Request("POST", Uri.parse("$baseUrl/preview"));
    req.body = jsonEncode(data.toJson());
    return _handleRequest(req);
  }
}

class PreviewModel {
  String? name;
  String? hauptBildBase64;
  String? geburtsDatum;
  List<String>? freunde;
  List<String>? freundeBilderBase64;
  List<String>? zitate;
  String? lieblingslehrer;
  String? lieblingsfaecher;
  String? lieblingsbeschaeftigung;
  String? plaene;
  String? groessterErfolg;
  String? krassestesErlebnis;
  String? einzigartigkeit;
  String? textVonFreunden;

  PreviewModel({
    this.name,
    this.hauptBildBase64,
    this.geburtsDatum,
    this.freunde,
    this.freundeBilderBase64,
    this.zitate,
    this.lieblingslehrer,
    this.lieblingsfaecher,
    this.lieblingsbeschaeftigung,
    this.plaene,
    this.groessterErfolg,
    this.krassestesErlebnis,
    this.einzigartigkeit,
    this.textVonFreunden,
  });

  factory PreviewModel.fromJson(Map<String, dynamic> json) {
    return PreviewModel(
      name: json["name"],
      hauptBildBase64: json['bild_base64'],
      geburtsDatum: json['geburts_datum'],
      freunde:
          json['freunde'] != null ? List<String>.from(json['freunde']) : null,
      freundeBilderBase64: json['freunde_bilder_base64'] != null
          ? List<String>.from(json['freunde_bilder_base64'])
          : null,
      zitate: json['zitate'] != null ? List<String>.from(json['zitate']) : null,
      lieblingslehrer: json['lieblingslehrer'],
      lieblingsfaecher: json['lieblingsfaecher'],
      lieblingsbeschaeftigung: json['lieblingsbeschaeftigung'],
      plaene: json['plaene'],
      groessterErfolg: json['groesster_erfolg'],
      krassestesErlebnis: json['krassestes_erlebnis'],
      einzigartigkeit: json['einzigartigkeit'],
      textVonFreunden: json['text_von_freunden'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'geburts_datum': geburtsDatum,
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

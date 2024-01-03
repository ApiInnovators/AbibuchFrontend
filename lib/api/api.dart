import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

class Api {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://abibuch.apiinnovators.de",
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      sendTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 20),
    ),
  );

  static Future<Response> _handleRequest(RequestOptions options) async {
    try {
      final response = await _dio.request(
        options.path,
        data: options.data,
        cancelToken: options.cancelToken,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
        options: Options(
          method: options.method,
          responseType: options.responseType,
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Response(
          data: "Verbindungsfehler, überprüfe deine Internetverbindung!",
          statusCode: HttpStatus.connectionClosedWithoutResponse,
          requestOptions: options,
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return Response(
          data: "Zeitüberschreitung bei Verbindungsaufbau.",
          statusCode: HttpStatus.networkConnectTimeoutError,
          requestOptions: options,
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return Response(
          data:
              "Zeitüberschreitung beim Empfang der Datei, bzw. dein Internet ist zu langsam.",
          statusCode: HttpStatus.requestTimeout,
          requestOptions: options,
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        return Response(
          data:
              "Zeitüberschreitung beim Senden der Datei. Du hast entweder eine langsame Internetverbindung oder deine Bilder sind zu groß.",
          statusCode: HttpStatus.requestTimeout,
          requestOptions: options,
        );
      } else {
        return Response(
          data: "$e",
          statusCode: 499,
          requestOptions: options,
        );
      }
    }
  }

  static Future<Response> preview(
    PreviewModel data, {
    void Function(int count, int total)? onSendProgress,
    void Function(int count, int total)? onReceiveProgress,
  }) async {
    final options = RequestOptions(
      path: "/preview",
      method: "POST",
      data: data.toJson(),
      responseType: ResponseType.bytes,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return _handleRequest(options);
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
  String? babyBildBase64;
  String? lehrerBildBase64;
  String? lehrerName;
  String? lehrerZitat;

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
    this.babyBildBase64,
    this.lehrerBildBase64,
    this.lehrerName,
    this.lehrerZitat,
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
      babyBildBase64: json['baby_bild_base64'],
      lehrerBildBase64: json['lehrer_bild_base64'],
      lehrerName: json['lehrer_name'],
      lehrerZitat: json['lehrer_zitat'],
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
        'baby_bild_base64': babyBildBase64,
        "lehrer_bild_base64": lehrerBildBase64,
        "lehrer_name": lehrerName,
        "lehrer_zitat": lehrerZitat,
      };
}

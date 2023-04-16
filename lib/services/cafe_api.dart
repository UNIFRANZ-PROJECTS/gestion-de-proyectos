import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projects/services/local_storage.dart';

// typedef MapOrFormData = Map<String, dynamic> | FormData;
// typedef Compare<T> = bool Function(T a, T b);

class CafeApi {
  static final _dio = Dio();
  static Future<void> configureDio() async {
    // Base del url
    _dio.options.baseUrl = 'http://localhost:8001/api';
    // Configurar Headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${LocalStorage.prefs.getString('token')}"
    };
    // _dio.options.validateStatus = (status) => status! <= 500;
    // _dio.httpClientAdapter = IOHttpClientAdapter()
    //   ..onHttpClientCreate = (_) {
    //     final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
    //     client.badCertificateCallback = (cert, host, port) => true;
    //     return client;
    //   }
    //   ..validateCertificate = (cert, host, port) {
    //     return true;
    //   };
  }

  static Future<bool> verifyInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        throw ('Error en el GET');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future httpGet(String path) async {
    try {
      debugPrint('==========================================');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.get(path);
      return resp;
    } on DioError catch (e) {
      debugPrint('${e.response}');
      rethrow;
    }
  }

  static Future post(String path, FormData? data) async {
    try {
      debugPrint('==========================================');
      debugPrint('== body $data');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.post(path, data: data);
      debugPrint('== status ${resp.statusCode}');
      return resp;
    } on DioError catch (e) {
      debugPrint('${e.response}');
      rethrow;
    }
  }

  static Future put(String path, FormData? data) async {
    try {
      debugPrint('==========================================');
      debugPrint('== body $data');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.put(path, data: data);
      debugPrint('== status ${resp.statusCode}');
      return resp;
    } on DioError catch (e) {
      debugPrint('${e.response}');
      rethrow;
    }
  }
}

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constant.dart';
import '../utils/pref_manager.dart';

class RequestDio {
  final String? url;
  final dynamic body;
  final Dio dio = Dio();
  //late SharedPreferences _prefs;

  RequestDio({this.url, this.body}) {
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${Prefs.getString(TOKEN)}';
  }

  Future<Response<dynamic>> post() async {
    if (kDebugMode) {
      print(
          'REQUEST DATA :-   URL IS = ${url} || body = ${body}  || Bearer ${Prefs.getString(TOKEN)}');
    }
    try {
      final response = await dio.post(url!, data: body);
      return response;
    } catch (e) {
      if (e is SocketException) {
        throw TimeoutException('Connection timeout. Please try again.');
      } else {
        if (kDebugMode) {
          print(e.toString());
        }
        throw Exception('Error occurred while making a request.');
      }
    }
  }
}

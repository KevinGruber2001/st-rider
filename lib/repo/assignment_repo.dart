import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/.env.dart';

class AssignmentRepo {
  static const String _baseUrl = serverUrl;

  final Dio _dio;
  static String? token;

  AssignmentRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<String> authenticate() async {
    if (token != null) return Future.value(token as String);

    final response = await _dio.get(_baseUrl + '/authenticate');
    token = response.data;
    return response.data as String;
  }

  Future<void> registerRequest(LatLng origin, LatLng destination) async {
    String authToken = await authenticate();

    final response = await _dio.post(
      _baseUrl + '/rider/registerRequest',
      data: jsonEncode(<String, dynamic>{
        'token': authToken,
        'begin': {'longitude': origin.longitude, 'latitude': origin.latitude},
        'end': {
          'longitude': destination.longitude,
          'latitude': destination.latitude
        }
      }),
    );
  }

  Future<void> cancelRequest() async {
    String authToken = await authenticate();

    final response = await _dio.post(_baseUrl + '/rider/cancelRequest',
        data: jsonEncode(<String, dynamic>{
          'token': authToken,
        }));
  }

  Future<bool> fetchAssignment() async {
    String authToken = await authenticate();

    final response = await _dio.post(_baseUrl + '/rider/fetchAssignment',
        data: jsonEncode(<String, dynamic>{
          'token': authToken,
        }));
    if (response.data["route"] == null) return false;
    return true;
  }
}

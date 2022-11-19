import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/.env.dart';
import 'package:rider/models/directions.model.dart';
import 'package:rider/models/place.model.dart';

class PlacesRepo {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cname%2Cgeometry&";

  final Dio _dio;

  PlacesRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Place>> getPlaces(String input) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'input': '${input}',
      'inputtype': 'textquery',
      'key': googleApiKey,
    });

    if (response.statusCode == 200) {
      List<Place> places = List<Place>.from(
          response.data["candidates"].map((model) => Place.fromMap(model)));
      return places;
    }
    return [];
  }
}

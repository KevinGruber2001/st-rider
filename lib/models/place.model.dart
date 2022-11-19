import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String formatedAddress;
  final LatLng location;
  final String name;

  Place(
      {required this.formatedAddress,
      required this.location,
      required this.name});

  factory Place.fromMap(Map<String, dynamic> map) {
    final data = map;

    dynamic local = data['geometry']['location'];

    LatLng location = LatLng(local['lat'], local['lng']);

    String formatedAddress = data['formatted_address'];

    String name = data['name'];

    return Place(
        formatedAddress: formatedAddress, location: location, name: name);
  }
}

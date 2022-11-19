import 'dart:async';
import 'dart:developer';
// REST Api
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/models/directions.model.dart';
import 'package:rider/models/place.model.dart';
import 'package:rider/pages/home/widgets/home_map.dart';
import 'package:rider/pages/waiting/waiting.dart';
import 'package:rider/repo/assignment_repo.dart';
import 'package:rider/repo/directions_repo.dart';
import 'package:rider/repo/place_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool showMap = true;

  closeMap() {
    setState(() {
      showMap = false;
    });
  }

  openMap() {
    setState(() {
      showMap = true;
    });
  }

  Marker? origin;
  Marker? destination;
  Directions? route;

  TextEditingController controllerOrigin = TextEditingController();
  TextEditingController controllerDestination = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 36,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ImageIcon(
              AssetImage("lib/assets/st-logo.png"),
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        title: const Text("Choose a location"),
      ),
      body: Column(children: [
        showMap
            ? Container(
                height: 500, child: HomeMapWidget(origin, destination, route))
            : Container(),
        Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(hintText: "Origin"),
                      controller: controllerOrigin),
                  suggestionsCallback: (pattern) async {
                    List<Place> places = await PlacesRepo().getPlaces(pattern);
                    return places;
                  },
                  itemBuilder: (context, places) {
                    return ListTile(
                      title: Text(places.name),
                    );
                  },
                  onSuggestionSelected: (place) {
                    controllerOrigin.value =
                        TextEditingValue().copyWith(text: place.name);
                    setState(() {
                      origin = Marker(
                        markerId: MarkerId("origin"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange),
                        position: LatLng(
                            place.location.latitude, place.location.longitude),
                      );
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(hintText: "Destination"),
                      controller: controllerDestination),
                  suggestionsCallback: (pattern) async {
                    List<Place> places = await PlacesRepo().getPlaces(pattern);
                    return places;
                  },
                  itemBuilder: (context, places) {
                    return ListTile(
                      title: Text(places.name),
                    );
                  },
                  onSuggestionSelected: (place) {
                    controllerDestination.value =
                        TextEditingValue().copyWith(text: place.name);
                    setState(() {
                      destination = Marker(
                        markerId: MarkerId("destination"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange),
                        position: LatLng(
                            place.location.latitude, place.location.longitude),
                      );
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: (origin != null) && (destination != null)
                      ? () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            if (origin != null && destination != null) {
                              Directions? directions = await DirectionsRepo()
                                  .getDirections(
                                      origin!.position, destination!.position);

                              if (directions != null) {
                                setState(() {
                                  route = directions;
                                });
                              }

                              //temporay located here
                              AssignmentRepo().registerRequest(
                                  origin!.position, destination!.position);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Waiting()));
                            }
                          }
                        }
                      : null,
                  child: const Text('Calculate'),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

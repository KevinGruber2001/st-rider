import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:rider/models/directions.model.dart';

class HomeMapWidget extends StatefulWidget {
  HomeMapWidget(this.origin, this.destination, this.route, {super.key});

  Marker? origin;
  Marker? destination;
  Directions? route;

  @override
  State<HomeMapWidget> createState() => _HomeMapWidgetState();
}

class _HomeMapWidgetState extends State<HomeMapWidget> {
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(48.26419697923386, 11.670701371430104), zoom: 11.5);

  late GoogleMapController _googleMapController;
  String? _mapStyle;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('lib/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      polylines: {
        if (widget.route != null)
          Polyline(
              polylineId: PolylineId('route'),
              color: Colors.orange,
              width: 5,
              points: widget.route!.polylinePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList())
      },
      onMapCreated: (controller) {
        _googleMapController = controller;
        _googleMapController.setMapStyle(_mapStyle);
      },
      markers: {
        if (widget.origin != null) widget.origin as Marker,
        if (widget.destination != null) widget.destination as Marker
      },
    );
  }
}

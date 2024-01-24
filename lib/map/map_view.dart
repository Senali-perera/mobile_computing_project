import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapView extends StatefulWidget {
  final double lat;
  final double lng;
  final String description;

  MapView({super.key, required this.lat, required this.lng, required this.description});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _currentPosition;
  List<LatLng> endLocations = [];
  String? _url;
  final String apiKey = "";
  late Future<void> _locationFuture;
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();
    _locationFuture = getLocation();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 1),
      'assets/images/current_location.png',
    );
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);
    setState(() {
      _currentPosition = location;
    });

    String _startLocation = "${_currentPosition?.latitude},${_currentPosition?.longitude}";
    String _endLocation = "${widget.lat},${widget.lng}";
    _url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$_startLocation&destination=$_endLocation&key=$apiKey';

    return fetchRouteCoordinates();
  }

  Future<void> fetchRouteCoordinates() async {
    var response = await http.get(Uri.parse(_url!));
    List<LatLng> locations = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var routes = data['routes'];
      if (routes != null && routes.isNotEmpty) {
        var legs = routes[0]['legs'];
        if (legs != null && legs.isNotEmpty) {
          var steps = legs[0]['steps'];
          if (steps != null) {
            locations.add(_currentPosition!);
            for (var step in steps) {
              var endLocation = step['end_location'];
              if (endLocation != null) {
                double lat = endLocation['lat'];
                double lng = endLocation['lng'];
                locations.add(LatLng(lat, lng));
              }
            }
          }
        }
      }
      setState(() {
        endLocations = locations;
      });
    } else {
      // Handle errors
    }
  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  CameraPosition get _kGooglePlex => CameraPosition(
    target: LatLng(widget.lat, widget.lng),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FutureBuilder(
        future: _locationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: endLocations,
                  color: Colors.blue,
                  width: 5,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId(""),
                  position: LatLng(widget.lat, widget.lng),
                  infoWindow: InfoWindow(
                    title: widget.description,
                  ),
                ),
                Marker(
                  markerId: MarkerId('myMarker'),
                  position: _currentPosition ?? LatLng(0.0,0.0),
                  icon: customIcon ?? BitmapDescriptor.defaultMarker, // Fallback to default marker if customIcon is not loaded yet
                  infoWindow: InfoWindow(title: 'My Location'),
                )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

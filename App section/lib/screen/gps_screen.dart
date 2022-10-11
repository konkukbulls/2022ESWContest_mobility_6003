import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLoader extends StatefulWidget {
  final String lat;
  final String lon;

  const MapLoader({super.key, required this.lat, required this.lon});

  @override
  State<MapLoader> createState() => MapLoaderState();
}

class MapLoaderState extends State<MapLoader> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.lat), double.parse(widget.lon)),
      // 위도, 경도
      zoom: 17.0, //확대 강도
    );

    final Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: '이벤트 발생 위치'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(double.parse(widget.lat), double.parse(widget.lon)),
    );

    final CameraPosition _kEvent = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(double.parse(widget.lat), double.parse(widget.lon)),
        // 위도, 경도
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    Future<void> _goToTheEvent() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kEvent));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("이벤트 발생 위치"),
        backgroundColor: Color(0xFF0E2B5B),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {_kGooglePlexMarker},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF0E2B5B),
        onPressed: _goToTheEvent,
        label: Text('자세히 보기'),
        icon: Icon(Icons.car_crash),
      ),
    );
  }

}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCarLocation extends StatefulWidget {

  final String lat2;
  final String lon2;

  const  MyCarLocation({super.key, required this.lat2, required this.lon2});

  @override
  State<MyCarLocation> createState() => MyCarLocationState();
}

class MyCarLocationState extends State<MyCarLocation> {
  Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.lat2), double.parse(widget.lon2)), // 위도, 경도
      zoom: 17.0, //확대 강도
    );

    final Marker kGooglePlexMarker = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: '내 차 위치'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(double.parse(widget.lat2), double.parse(widget.lon2)),
    );

    final CameraPosition kEvent = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(double.parse(widget.lat2), double.parse(widget.lon2)),
        // 위도, 경도
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    Future<void> _goToMyCar() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(kEvent));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("내 차 위치"),
        backgroundColor: Color(0xFF0E2B5B),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {kGooglePlexMarker},
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF0E2B5B),
        onPressed: _goToMyCar,
        label: Text('자세히 보기'),
        icon: Icon(Icons.car_crash),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:bccs/model/weather_network.dart';
import 'package:bccs/model/get_location.dart';

const apiKey = '88687b96f507c1b339ca26b16c001856';

class MyLocation extends StatefulWidget {
  const MyLocation({Key? key}) : super(key: key);

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {

  late double latitude3;
  late double longitude3;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {

    CurrentLocation currentLocation = CurrentLocation();
    await currentLocation.getMyCurrentLocation();
    latitude3 = currentLocation.latitude2!;
    longitude3 = currentLocation.longitude2!;
    print(latitude3);
    print(longitude3);

    Network network = Network('https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$apiKey&units=metric');

    var weatherData = await network.getJsonData();
    print(weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          getLocation();
        },
        child: Text(
          "내 위치 업데이트",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

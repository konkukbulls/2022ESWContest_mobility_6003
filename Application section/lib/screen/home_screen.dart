// Homescreen : 최근 이벤트(다운로드) 페이지
// 기능 : 영상 시청, 서버 연결

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:bccs/model/weather_network.dart';
import 'package:bccs/model/get_location.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bccs/model/weather_icon.dart';
import 'mycarlocation_screen.dart';

const apiKey = '88687b96f507c1b339ca26b16c001856';

// *상태관리
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.app});

  final FirebaseApp app;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseReference mycarlocationRef;
  WeatherIcon weatherIcon = WeatherIcon();

  String? lat2;
  String? lon2;

  String? cityName;
  double? temp;
  double? latitude3;
  double? longitude3;
  Widget? icon;
  var condition;
  var date = DateTime.now();

  var mypresentcar;

  @override
  void initState() {
    getLocation();
    final database = FirebaseDatabase.instanceFor(app: widget.app);
    mycarlocationRef = database.ref().child('location');

    super.initState();
  }

  // 현재 위치 및 날씨 가져오기
  Future<Widget?> getLocation() async {
    CurrentLocation currentLocation = CurrentLocation();
    await currentLocation.getMyCurrentLocation();
    latitude3 = currentLocation.latitude2;
    longitude3 = currentLocation.longitude2;
    print(latitude3);
    print(longitude3);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$apiKey&units=metric');

    var weatherData = await network.getJsonData();
    print(weatherData);

    temp = weatherData['main']['temp'];
    cityName = weatherData['name'];
    condition = weatherData['weather'][0]['id'];

    print(temp);
    print(cityName);
    print(condition);

    if (condition != null) {
      icon = weatherIcon.getWeatherIcon(condition)!;
    } else {
      icon = SvgPicture.asset('svg/cloud_sun.svg',
          color: Colors.black87, fit: BoxFit.contain);
    }
    return null;
  }


  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("h:mm a").format(now);
  }

  // 차 현재 위치 받아오기
  StreamBuilder<DatabaseEvent> CarLocation() {
    return StreamBuilder(
        stream: mycarlocationRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            lat2 = map["lat2"].toString();
            lon2 = map["lon2"].toString();

            return Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 100,
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: ListTile(
                    // leading: Icon(Icons.health_and_safety, size: 50, color: Color(0xFF0E2B5B),),
                    title: Text("오늘도\n안전운전 하세요!",
                        style: GoogleFonts.lato(
                            fontSize: 17, color: Colors.black)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E2B5B),
                          fixedSize: Size(140, 90)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyCarLocation(lat2: lat2!, lon2: lon2!)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("내 차 위치  ",
                              style: GoogleFonts.lato(
                                  fontSize: 17, color: Colors.white)),
                          Icon(Icons.location_on),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  // override를 통해 Widget build를 가져옴
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // 배경 투명하게 설정
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text("빌트인 캠 클라우드",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          backgroundColor: Colors.white,
          actions: [
            SizedBox(
              height: 15,
              child: TextButton(
                onPressed: () {
                  ConnectCloud(context);
                },
                style: ButtonStyle(),
                child: Icon(Icons.cloud_done_rounded,
                    size: 20, color: Color(0xFF0E2B5C)),
              ),
            ),
          ],
          elevation: 0, // AppBar 그림자 설정(0은 그림자 X)
        ),
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text("나의 대표차량",
                        style:
                            GoogleFonts.lato(fontSize: 25, color: Colors.black)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12.5),
                    child: TextButton(
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Colors.black87,
                        size: 20,
                      ),
                      style: TextButton.styleFrom(
                          minimumSize: Size(5, 5),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: () {
                        PickMyCar(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text("349구 7896",
                      style: GoogleFonts.lato(fontSize: 17, color: Colors.black)),
                ]),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Image(
                  image: AssetImage("assets/palisade_black.png"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text("PALISADE",
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "HYUNDAI",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E2B5B)),
                      onPressed: () {
                        // getLocation();
                        setState(() {
                          getLocation();
                          WeatherIcon();
                        });
                      },
                      child: Text("현재 위치 업데이트",
                          style: GoogleFonts.lato(
                              fontSize: 14, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(DateFormat('yyy년 MM월 d일 ').format(date),
                            style: GoogleFonts.lato(
                                fontSize: 12.0, color: Colors.black)),
                        TimerBuilder.periodic(
                          (Duration(minutes: 1)),
                          builder: (context) {
                            print('${getSystemTime()}');
                            return Text(
                              '${getSystemTime()}',
                              style: GoogleFonts.lato(
                                  fontSize: 12.0, color: Colors.black),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: ListTile(
                            leading: icon != null
                                ? SizedBox(width: 35, child: icon!)
                                : SizedBox(
                                    width: 35,
                                    child: Icon(
                                      Icons.location_disabled_rounded,
                                      size: 25,
                                      color: Colors.black87,
                                    ),
                                  ),
                            title: temp != null
                                ? Text('$temp\u2103',
                                    style: GoogleFonts.lato(
                                        fontSize: 25.0, color: Colors.black))
                                : Text(
                                    "위치 업데이트가 필요합니다.",
                                    style: GoogleFonts.lato(
                                        fontSize: 17, color: Colors.black),
                                  ),
                            trailing: temp != null
                                ? Text(
                                    '$cityName',
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.black),
                                  )
                                : Text(""),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CarLocation(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> ConnectCloud(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      actionsAlignment: MainAxisAlignment.end,
      title: Text('네트워크 설정',
          style: GoogleFonts.lato(fontSize: 20, color: Colors.black)),
      content: Text('클라우드와 안전하게 연결되었습니다.',
          style: GoogleFonts.lato(fontSize: 16, color: Colors.black)),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0E2B5C),
              padding: EdgeInsets.only(right: 1)),
          child: Text('확인',
              style: GoogleFonts.lato(fontSize: 15, color: Colors.white)),
        ),
      ],
    ),
  );
}

Future<dynamic> PickMyCar(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      actionsAlignment: MainAxisAlignment.end,
      title: Row(
        children: [
          Icon(Icons.drive_eta),
          Text(' 현재 등록된 차량',
              style: GoogleFonts.lato(fontSize: 20, color: Colors.black)),
        ],
      ),
      // icon: Icon(Icons.check),
      content: Text('349구 7896 (PALISADE)',
          style: GoogleFonts.lato(fontSize: 17, color: Colors.black)),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0E2B5C),
              padding: EdgeInsets.only(right: 1)),
          child: Text('확인',
              style: GoogleFonts.lato(fontSize: 15, color: Colors.white)),
        ),
      ],
    ),
  );
}

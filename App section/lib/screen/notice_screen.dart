// notice_screen : 알림 페이지
// 기능 : 빌트인 캠 연결 알림, 충격 감지 알림 및 해당 영상 재생, 사고 위치 정보 제공

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../model/video_model.dart';
import '../widget/video_player.dart';

// *상태관리
class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key, required this.app});

  final FirebaseApp app;

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
// final DatabaseReference _database = FirebaseDatabase().reference();
// FirebaseMessaging? _fcm;
}

class _NoticeScreenState extends State<NoticeScreen> {
  late DatabaseReference _parkmediaRef;
  late DatabaseReference _drivemediaRef;

  static DateTime dateTime = DateTime.now();
  String selectdate = DateFormat('yyyyMMdd').format(dateTime);
  String? message;
  String? token;

  @override
  // initState()는 한 번만 호출되며 일회성 초기화에 사용된다.
  void initState() {
    final database = FirebaseDatabase.instanceFor(app: widget.app);
    _drivemediaRef = database.ref().child('drive').child(selectdate);
    _parkmediaRef = database.ref().child('park').child(selectdate);
    getToken();
    super.initState();
  }

  // override를 통해 Widget build를 가져옴
  @override
  Widget build(BuildContext context) {
    final kTabs = [
      Tab(
        child: Text(
          '주행 중 이벤트',
          style: TextStyle(color: Colors.black),
        ),
      ),
      Tab(
        child: Text(
          '주차 중 이벤트',
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];

    return DefaultTabController(
      length: kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("알림",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
          // AppBar 그림자 설정(0은 그림자 X)
          actions: [
            const SizedBox(height: 30),
            ElevatedButton(
              child: Icon(Icons.calendar_month, color: Colors.black),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, elevation: 0),
              onPressed: () async {
                final date = await pickDate();
                if (date == null) return; //pressed 'CANCEL'

                setState(() {
                  dateTime = date;
                  selectdate = DateFormat('yyyyMMdd').format(dateTime);
                });
              },
            ),
          ],
          bottom: TabBar(
            tabs: kTabs,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              height: 40,
              child: Text(
                '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TabBarView(
                  children: [showDriveNotification(context), showParkNotification(context)]),
            ),
          ],
        ),
      ),
    );
  }

  showDriveNotification(BuildContext context) {
    return SizedBox(
      child: FirebaseAnimatedList(
        query: _drivemediaRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          VideoModel videoModel =
              VideoModel.fromJson(json.decode(json.encode(snapshot.value)));
          var value = Map<String, dynamic>.from(snapshot.value as Map);
          var time1 = value["time"];
          var ment1 = value["notice"];
          return Column(
            children: [
              SizedBox(
                height: 70,
                child: ListTile(
                  leading: Icon(
                    Icons.car_crash,
                    size: 27,
                    color: Color(0xFF0E2B5B),
                  ),
                  title: Text("$ment1"),
                  subtitle: Text(time1.toString()),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoScreen(
                                  time: videoModel.time!,
                                  mediaurl: videoModel.drivemediaurl!)));
                    },
                    icon: Icon(
                      Icons.play_circle,
                      size: 27,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  showParkNotification(BuildContext context) {
    return SizedBox(
      child: FirebaseAnimatedList(
        query: _parkmediaRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          VideoModel videoModel =
              VideoModel.fromJson(json.decode(json.encode(snapshot.value)));
          var value = Map<String, dynamic>.from(snapshot.value as Map);
          var time2 = value["time"];
          var ment2 = value["notice"];
          return Column(
            children: [
              SizedBox(
                height: 70,
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    size: 27,
                    color: Color(0xFF0E2B5B),
                  ),
                  title: Text("$ment2"),
                  subtitle: Text(time2.toString()),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoScreen(
                                  time: videoModel.time!,
                                  mediaurl: videoModel.parkmediaurl!)));
                    },
                    icon: Icon(
                      Icons.play_circle,
                      size: 27,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    final DatabaseReference database = FirebaseDatabase().reference();
    database.child('fcm-token/$token').set({"token": token});
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}

// function update 터미널
// firebase deploy --only functions

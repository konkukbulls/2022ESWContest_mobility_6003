import 'package:bccs/screen/gps_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bccs/model/video_model.dart';
import 'package:bccs/widget/video_player.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:convert';


class VideoScreenLoader extends StatefulWidget {
  const VideoScreenLoader({Key? key, required this.title, required this.app})
      : super(key: key);

  final String title;
  final FirebaseApp app;

  @override
  _VideoScreenLoaderState createState() => _VideoScreenLoaderState();
}

class _VideoScreenLoaderState extends State<VideoScreenLoader> {
  late DatabaseReference _parkmediaRef;
  late DatabaseReference _drivemediaRef;

  static DateTime dateTime = DateTime.now();
  String selectdate = DateFormat('yyyyMMdd').format(dateTime);

  @override
  // 일회성 초기화
  void initState() {
    final database = FirebaseDatabase.instanceFor(app: widget.app);
    _drivemediaRef = database.ref().child('drive').child(selectdate);
    _parkmediaRef = database.ref().child('park').child(selectdate);
    super.initState();
  }

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
          actionsIconTheme: IconThemeData(size: 25, color: Colors.black),
          title: Text("녹화영상",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          backgroundColor: Colors.white,
          actions: [
            const SizedBox(height: 20),
            // 달력(날짜 선택)
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
          elevation: 0,
          bottom: TabBar(
            tabs: kTabs,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 선택한 날짜 보기
            Container(
              padding: EdgeInsets.only(top: 10),
              height: 40,
              child: Text(
                '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // 각 탭 화면 불러오기
            Expanded(
              child: TabBarView(
                  children: [showDrivemedia(context), showParkmedia(context)]),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 기능
  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  // 주행 중 이벤트 영상 불러오기
  showDrivemedia(BuildContext context) {
    return SizedBox(
      child: FirebaseAnimatedList(
        defaultChild: const Center(child: CircularProgressIndicator()),
        padding: const EdgeInsets.all(0.0),
        query: _drivemediaRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          VideoModel videoModel =
              VideoModel.fromJson(json.decode(json.encode(snapshot.value)));

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoScreen(
                          time: videoModel.time!,
                          mediaurl: videoModel.drivemediaurl!)));
            },
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: videoModel.drivethumbnail != null
                              ? Image.network(
                                  videoModel.drivethumbnail!,
                                  fit: BoxFit.fill,
                                )
                              : Text(
                                  "오류 발생",
                                  style: GoogleFonts.lato(
                                      fontSize: 17, color: Colors.black),
                                ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 공유하기 버튼
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0E2B5B),
                                  fixedSize: Size(120, 30)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: videoModel.drivemediaurl!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Copied to clipboard')));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.share_outlined,
                                      size: 20, color: Colors.white),
                                  Text(" 공유하기"),
                                ],
                              ),
                            ),
                            // 이벤트 발생 위치 보기 기능
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0E2B5B),
                                  fixedSize: Size(190, 30)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapLoader(
                                            lat: videoModel.lat!,
                                            lon: videoModel.lon!)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 22, color: Colors.white),
                                  Text("이벤트 발생 위치 보기"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        indent: 22,
                        endIndent: 22,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                showPlayButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Play 버튼
  showPlayButton() {
    return Positioned(
      bottom: 150,
      right: 100,
      child: Container(
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.transparent,
        ),
        child: const Icon(
          Icons.play_arrow,
          shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  // 주차 영상 불러오기
  showParkmedia(BuildContext context) {
    return SizedBox(
      child: FirebaseAnimatedList(
        defaultChild: const Center(child: CircularProgressIndicator()),
        padding: const EdgeInsets.all(0.0),
        query: _parkmediaRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          VideoModel videoModel =
              VideoModel.fromJson(json.decode(json.encode(snapshot.value)));

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoScreen(
                          time: videoModel.time!,
                          mediaurl: videoModel.parkmediaurl!)));
            },
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            videoModel.parkthumbnail!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0E2B5B),
                                  fixedSize: Size(120, 30)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: videoModel.parkmediaurl!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Copied to clipboard')));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.share_outlined,
                                      size: 20, color: Colors.white),
                                  Text(" 공유하기"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0E2B5B),
                                  fixedSize: Size(190, 30)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapLoader(
                                            lat: videoModel.lat!,
                                            lon: videoModel.lon!)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 22, color: Colors.white),
                                  Text("이벤트 발생 위치 보기"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        indent: 22,
                        endIndent: 22,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                showPlayButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

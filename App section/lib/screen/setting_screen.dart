// setting_screen : 설정 페이지
// 기능 : 빌트인 캠(네트워크) 연결, 개발자

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

// *상태관리
class SettingScreen extends StatefulWidget {

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool notifications = true;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("설정",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0, // AppBar 그림자 설정(0은 그림자 X)
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: Card(
                  surfaceTintColor: Color(0xFF0E2B5B),
                  elevation: 2,
                  child: NotificationSetting()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: Card(
                  elevation: 2,
                  child: ListTile(
                      leading: Icon(
                        Icons.drive_eta,
                        size: 25,
                        color: Color(0xFF0E2B5B),
                      ),
                      title: Text(
                        "내 차 설정",
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        color: Color(0xFF0E2B5B),
                        onPressed: () {
                          mycarSetting(context);
                        },
                      ))),
            ),
          ],
        ),
      ),
    );
  }

  NotificationSetting() {
    return ListTile(
      leading: Icon(
        // Wifi icon is updated based on switch value.
          notifications ? CupertinoIcons.bell_solid : CupertinoIcons.bell_slash_fill,
          color: Color(0xFF0E2B5B)
        // color: notifications
        //     ? CupertinoColors.black
        //     : CupertinoColors.systemRed,
      ),
      title: Text(
        "알림 설정",
        style: TextStyle(fontSize: 20),
      ),
      trailing: CupertinoSwitch(
        // This bool value toggles the switch.
        value: notifications,
        thumbColor: CupertinoColors.white,
        trackColor: CupertinoColors.activeBlue.withOpacity(0.14),
        activeColor: Color(0xFF0E2B5B),
        onChanged: (bool? value) {
          // This is called when the user toggles the switch.
          setState(() {
            notifications = value!;
          });
        },
      ),
    );
  }
}


Future<dynamic> mycarSetting(BuildContext context) {
  return showDialog(
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      title: Text('내 차 설정',
              style: GoogleFonts.lato(fontSize: 20, color: Colors.black)),
      // icon: Icon(Icons.check),
      content: Container(
        height: 140,
        // width: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('349구 7896 (PALISADE)',
                style: GoogleFonts.lato(fontSize: 17, color: Colors.black)),
            TextButton(onPressed: () {}, child: Text("+ 차량 추가하기", style: TextStyle(color: Color(0xFF0E2B5C)),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
          ],
        ),
      ),
    ),
  );
}
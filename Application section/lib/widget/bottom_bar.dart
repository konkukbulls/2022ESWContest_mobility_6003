import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            labelColor: Color(0xFF0E2B5C),
            unselectedLabelColor: Colors.black38,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Color(0xFF0E2B5C),
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home_filled,
                  size: 27,
                ),
                text: '홈',
                iconMargin: EdgeInsets.only(bottom: 3),
              ),
              Tab(
                icon: Icon(
                  Icons.linked_camera_sharp,
                  size: 27,
                ),
                text: '녹화영상',
                iconMargin: EdgeInsets.only(bottom: 3),
              ),
              Tab(
                icon: Icon(
                  Icons.notifications,
                  size: 27,
                ),
                text: '알림',
                iconMargin: EdgeInsets.only(bottom: 3),
              ),
              Tab(
                icon: Icon(
                  Icons.settings,
                  size: 27,
                ),
                text: '설정',
                iconMargin: EdgeInsets.only(bottom: 3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
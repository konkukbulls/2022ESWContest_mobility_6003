import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget{
  final String time, mediaurl;

  VideoScreen({required this.time, required this.mediaurl});

  @override
  _VideoScreenState createState() => _VideoScreenState();

}

class _VideoScreenState extends State<VideoScreen> {
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(aspectRatio: 16/9, fit: BoxFit.contain);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.mediaurl);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.time}'),
      foregroundColor: Colors.black.withOpacity(0.6),
      backgroundColor: Colors.white),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(child: AspectRatio(
              aspectRatio: 16/9,
              child: BetterPlayer(
                key: _betterPlayerKey,
                controller: _betterPlayerController,
              )
          ),
          )
        ],
      ),
    );
  }
}
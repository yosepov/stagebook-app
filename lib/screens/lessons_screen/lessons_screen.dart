import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonsScreen extends StatefulWidget {
  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String _lessonUrl =
      'https://www.youtube.com/watch?v=5qap5aO4i9A&ab_channel=ChilledCow';
  YoutubePlayerController _youtubePlayerController;
  YoutubePlayerFlags _youtubePlayerFlags = YoutubePlayerFlags(
    autoPlay: false,
    controlsVisibleAtStart: false,
  );

  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_lessonUrl),
        flags: _youtubePlayerFlags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Lessons',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          YoutubePlayer(
            controller: _youtubePlayerController,
            liveUIColor: Colors.red,
            progressColors: ProgressBarColors(
              backgroundColor: Colors.red,
              playedColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

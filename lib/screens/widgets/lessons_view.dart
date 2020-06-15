import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/comments_screen/lesson_comments_screen.dart';
import 'package:stagebook/screens/widgets/description_text_widget.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonsView extends StatefulWidget {
  final String currentUserId;
  final Lesson lesson;
  final User author;

  LessonsView({this.author, this.currentUserId, this.lesson});
  @override
  _LessonsViewState createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  int _starCount = 0;
  bool _isStared = false;
  bool _heartAnim = false;
  YoutubePlayerController _youtubePlayerController;
  YoutubePlayerFlags _youtubePlayerFlags = YoutubePlayerFlags(
    autoPlay: false,
    hideControls: true,
    controlsVisibleAtStart: false,
  );

  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.lesson.youtubeUrl),
        flags: _youtubePlayerFlags);
    _starCount = widget.lesson.starCount;

    _initPoststaredAccent();

    super.initState();
  }

  @override
  void didUpdateWidget(LessonsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.starCount != widget.lesson.starCount) {
      _starCount = widget.lesson.starCount;
    }
  }

  _initPoststaredAccent() async {
    bool isStaredAccent = await DatabaseService.didStarLesson(
      currentUserId: widget.currentUserId,
      lesson: widget.lesson,
    );
    if (mounted) {
      setState(() {
        _isStared = isStaredAccent;
      });
    }
  }

  _starPost() {
    if (_isStared) {
      // Unstar Post
      DatabaseService.unstarLesson(
          currentUserId: widget.currentUserId, lesson: widget.lesson);
      setState(() {
        _isStared = false;
        _starCount = _starCount - 1;
      });
    } else {
      // star Post
      DatabaseService.starLesson(
          currentUserId: widget.currentUserId, lesson: widget.lesson);
      setState(() {
        _heartAnim = true;
        _isStared = true;
        _starCount = _starCount + 1;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white10,
            Colors.white,
            Colors.white,
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.grey,
                backgroundImage: widget.author.profileImageUrl == null
                    ? AssetImage('assets/images/placeholder_profile_image.png')
                    : CachedNetworkImageProvider(widget.author.profileImageUrl),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  widget.lesson.lessonTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[300]),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.lesson.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.redAccent,
                            ),
                            iconSize: 200.0,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonCommentScreen(
                                  lesson: widget.lesson,
                                  starCount: _starCount,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // YoutubePlayer(
          //   controller: _youtubePlayerController,
          //   liveUIColor: Colors.black,
          //   progressColors: ProgressBarColors(
          //     backgroundColor: Colors.black,
          //     playedColor: Colors.redAccent,
          //   ),
          //   progressIndicatorColor: Colors.yellow,
          // ),
          Row(
            children: <Widget>[
              IconButton(
                icon: _isStared
                    ? Icon(
                        Icons.star,
                        color: Colors.yellow,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.black,
                      ),
                iconSize: 30.0,
                onPressed: _starPost,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                  '${_starCount.toString()} stars',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          _heartAnim
              ? Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.5, end: 1.4),
                  curve: Curves.elasticOut,
                  builder: (anim) => Transform.scale(
                    scale: anim.value,
                    child: Icon(
                      Icons.star,
                      size: 60.0,
                      color: Colors.yellow[400],
                    ),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 30.0,
          ),
          DescriptionTextWidget(text: widget.lesson.description),

          SizedBox(
            height: 30.0,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

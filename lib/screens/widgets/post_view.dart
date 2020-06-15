import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/comments_screen/post_comments_screen.dart';
import 'package:stagebook/screens/profile_screen/profile_screen.dart';
import 'package:stagebook/services/database_service.dart';

import 'package:video_player/video_player.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _starCount = 0;
  bool _isStared = false;
  bool _heartAnim = false;
  VideoPlayerController _controller;
  Future<void> _initVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('${widget.post.imageUrl}');
    _starCount = widget.post.starCount;
    _initPoststared();
    _initVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.starCount != widget.post.starCount) {
      _starCount = widget.post.starCount;
    }
  }

  _initPoststared() async {
    bool isStared = await DatabaseService.didStarPost(
      currentUserId: widget.currentUserId,
      post: widget.post,
    );
    if (mounted) {
      setState(() {
        _isStared = isStared;
      });
    }
  }

  _starPost() {
    if (_isStared) {
      // Unstar Post
      DatabaseService.unstarPost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _isStared = false;
        _starCount = _starCount - 1;
      });
    } else {
      // star Post
      DatabaseService.starPost(
          currentUserId: widget.currentUserId, post: widget.post);
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
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                currentUserId: widget.currentUserId,
                userId: widget.post.authorId,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.author.profileImageUrl == null
                      ? AssetImage(
                          'assets/images/placeholder_profile_image.png')
                      : CachedNetworkImageProvider(
                          widget.author.profileImageUrl),
                ),
                SizedBox(width: 8.0),
                Text(
                  widget.author.fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: _starPost,
          child: widget.post.video == true
              ? FutureBuilder(
                  future: _initVideoPlayerFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.post.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                size: 100.0,
                                color: Colors.yellow[400],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  IconButton(
                    icon: Icon(
                      Icons.comment,
                      color: Colors.black,
                    ),
                    iconSize: 30.0,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostCommentScreen(
                          post: widget.post,
                          starCount: _starCount,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${_starCount.toString()} stars',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 12.0,
                      right: 6.0,
                    ),
                    child: Text(
                      widget.author.fullName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.post.caption,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ],
    );
  }
}

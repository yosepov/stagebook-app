import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/activity_screen/activities_screen.dart';
import 'package:stagebook/screens/add_new_product_screen/add_product_screen.dart';
import 'package:stagebook/screens/create_post_screen/create_liveshow_post_screen.dart';
import 'package:stagebook/screens/create_post_screen/create_post_screen.dart';
import 'package:stagebook/screens/create_show_screen/create_Show_screen.dart';
import 'package:stagebook/screens/lessons_screen/create_lesson.dart';
import 'package:stagebook/screens/stars_screen/stars_screen.dart';
import 'package:stagebook/services/auth_service.dart';

import 'drawer_widget.dart';

class ProfileScreenAppBar extends StatefulWidget {
  User user;
  bool isUser;
  ProfileScreenAppBar({this.user, this.isUser});

  @override
  _ProfileScreenAppBarState createState() => _ProfileScreenAppBarState();
}

class _ProfileScreenAppBarState extends State<ProfileScreenAppBar> {
  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Upload',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Photo',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CreatePostScreen.id);
                },
              ),
              // CupertinoActionSheetAction(
              //   child: Text(
              //     'upload show',
              //     style: TextStyle(
              //       color: Colors.grey[700],
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              //   onPressed: () {
              //     Navigator.pushNamed(context, CreateLiveShowPostScreen.id);
              //   },
              // ),
              CupertinoActionSheetAction(
                child: Text(
                  'lesson',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CreateLessonScreen.id);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Live Show Post',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CreateLiveShowPostScreen.id);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AddProductScreen.id);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _appBarBuild(AuthService authService, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[800],
      title: Row(
        children: <Widget>[
          Text(
            '${widget.user.nickname == null ? '' : widget.user.nickname}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[300],
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add_circle),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () => _iosBottomSheet(),
        ),
        // IconButton(
        //   icon: Icon(Icons.home),
        //   iconSize: 30.0,
        //   color: Colors.grey,
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (_) => HomeScreen()));
        //   },
        // ),
      ],
    );
  }

  _appBarBuildOtherUser(AuthService authService, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[600],
      title: Row(
        children: <Widget>[
          Text(
            '${widget.user.nickname == null ? '' : widget.user.nickname}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[300],
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.star),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => StarsScreen()));
          },
        ),
        widget.isUser == false
            ? IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {},
              )
            : IconButton(
                icon: Icon(Icons.notifications_active),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ActivityScreen()));
                },
              ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (widget.isUser) {
      return _appBarBuild(authService, context);
    } else {
      return _appBarBuildOtherUser(authService, context);
    }
  }
}

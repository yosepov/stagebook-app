import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/activity_model.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/live_show_post_model.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/comments_screen/lesson_comments_screen.dart';
import 'package:stagebook/screens/comments_screen/post_comments_screen.dart';
import 'package:stagebook/services/auth_service.dart';
import 'package:stagebook/services/database_service.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;

  ActivityScreen({this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> _activities = [];

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  _setupActivities() async {
    List<Activity> activities =
        await DatabaseService.getActivities(widget.currentUserId);

    setState(() {
      _activities = activities;
    });

    print(activities);
  }

  _buildActivity(Activity activity) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(activity.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User user = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage('assets/images/placeholder_profile_image.png')
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: activity.comment != null
              ? Text('${user.fullName} commented: "${activity.comment}"')
              : Text('${user.fullName} star your post'),
          subtitle: Text(
            DateFormat.yMd().add_jm().format(activity.timestamp.toDate()),
          ),
          trailing: CachedNetworkImage(
            imageUrl: activity.postImageUrl == null
                ? 'assets/images/stage_icon.png'
                : activity.postImageUrl,
            height: 40.0,
            width: 40.0,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            String currentUserId =
                Provider.of<UserData>(context, listen: false).currentUserId.uid;
            Post post = await DatabaseService.getUserPost(
              currentUserId,
              activity.postId,
            );

            if (post != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostCommentScreen(
                      post: post,
                      starCount: post.starCount,
                    ),
                  ));
              return;
            }

            LiveShowPost liveShowPost =
                await DatabaseService.getUserLiveShowPost(
              currentUserId,
              activity.postId,
            );

            if (liveShowPost != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostCommentScreen(
                      starCount: liveShowPost.starCount,
                      liveShowPost: liveShowPost,
                    ),
                  ));
              return;
            }

            Lesson lesson = await DatabaseService.getUserLesson(
              currentUserId,
              activity.postId,
            );

            if (lesson != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonCommentScreen(
                      starCount: lesson.starCount,
                      lesson: lesson,
                    ),
                  ));
              return;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.red,
            fontSize: 35.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () => authService.logout(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupActivities(),
        child: ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (BuildContext context, int index) {
            Activity activity = _activities[index];
            return _buildActivity(activity);
          },
        ),
      ),
    );
  }
}

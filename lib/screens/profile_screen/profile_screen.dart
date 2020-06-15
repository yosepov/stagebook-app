import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/live_show_post_model.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/comments_screen/post_comments_screen.dart';
import 'package:stagebook/screens/profile_screen/widgets/drawer_widget.dart';
import 'package:stagebook/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:stagebook/screens/profile_screen/widgets/profile_screen_info.dart';
import 'package:stagebook/screens/widgets/lessons_view.dart';
import 'package:stagebook/screens/widgets/post_liveShow_view.dart';
import 'package:stagebook/screens/widgets/post_view.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/utilities.dart/constants.dart';

class ProfileScreen extends StatefulWidget {
  String userId;
  User user;
  String currentUserId;
  ProfileScreen({this.userId, this.user, this.currentUserId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSubscribing = false;
  bool _isUser;
  int _subscriberCount = 0;
  int _subscribingCount = 0;
  List<Post> _photoPosts = [];
  List<LiveShowPost> _liveShowPosts = [];
  List<Lesson> _lessons = [];
  int _displayPosts = 0; // 0 - grid layout, 1 - column layout
  User _profileUser;
  SnackBar snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      'You must be VIP user!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    action: SnackBarAction(
      label: 'Go VIP!',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    _setupProfileUser();
    _setupIsSubscribing();
    _setupSubscribers();
    _setupSubscribing();
    _setupPosts();
    _setupLiveShowPosts();
    _setupLessons();
    _isThisUser();
  }

  _isThisUser() {
    if (widget.currentUserId == widget.userId) {
      setState(() {
        _isUser = true;
      });
    } else {
      setState(() {
        _isUser = false;
      });
    }
  }

  _setupIsSubscribing() async {
    bool isSubscribingUser = await DatabaseService.isSubscribingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isSubscribing = isSubscribingUser;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _setupSubscribers() async {
    int userSubscribersCount =
        await DatabaseService.numSubscribers(widget.userId);
    setState(() {
      _subscriberCount = userSubscribersCount;
    });
  }

  _setupSubscribing() async {
    int userSubscribingCount =
        await DatabaseService.numSubscribing(widget.userId);
    setState(() {
      _subscribingCount = userSubscribingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _photoPosts = posts;
    });
  }

  _setupLiveShowPosts() async {
    List<LiveShowPost> posts =
        await DatabaseService.getUserLiveShowPosts(widget.userId);
    setState(() {
      _liveShowPosts = posts;
    });
  }

  _setupLessons() async {
    List<Lesson> posts = await DatabaseService.getUserLessons(widget.userId);
    setState(() {
      _lessons = posts;
    });
  }

  _subscribeOrUnsubscribe() {
    if (_isSubscribing) {
      _unsubscribeUser();
    } else {
      _subscribeUser();
    }
  }

  _unsubscribeUser() {
    DatabaseService.unsubscribeUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isSubscribing = false;
      _subscriberCount--;
    });
  }

  _subscribeUser() {
    DatabaseService.subscribeUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      _isSubscribing = true;
      _subscriberCount = _subscriberCount + 1;
    });
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostCommentScreen(
              post: post,
              starCount: post.starCount,
            ),
          ),
        ),
        child: Image(
          image: CachedNetworkImageProvider(post.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      //Grid
      List<GridTile> tiles = [];
      _photoPosts.forEach(
        (post) => tiles.add(_buildTilePost(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        children: tiles,
      );
    } else if (_displayPosts == 1) {
      //column
      List<PostView> postViews = [];

      _photoPosts.forEach((post) {
        postViews.add(PostView(
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(children: postViews);
    } else if (_displayPosts == 2) {
      //column
      List<PostLiveShowView> liveShowPostViews = [];
      _liveShowPosts.forEach((post) {
        liveShowPostViews.add(PostLiveShowView(
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(children: liveShowPostViews);
    } else if (_displayPosts == 3) {
      //column
      List<LessonsView> lessonsView = [];
      _lessons.forEach((post) {
        lessonsView.add(LessonsView(
          currentUserId: widget.currentUserId,
          author: _profileUser,
          lesson: post,
        ));
      });
      return Column(children: lessonsView);
    }
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () => setState(() {
            _displayPosts = 1;
          }),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundImage: _profileUser.profileImageUrl == null
                    ? AssetImage('assets/images/placeholder_profile_image.png')
                    : CachedNetworkImageProvider(_profileUser.profileImageUrl),
              ),
              Text(
                'photos',
                style: TextStyle(
                    color: _displayPosts == 1
                        ? Colors.redAccent
                        : Colors.grey[600]),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.credit_card,
                color: _displayPosts == 2 ? Colors.red : Colors.grey[600],
              ),
              iconSize: 40.0,
              color: _displayPosts == 0 ? Colors.grey[300] : Colors.white,
              onPressed: () => setState(() {
                _displayPosts = 2;
              }),
            ),
            Text(
              'tickets',
              style: TextStyle(
                  color:
                      _displayPosts == 2 ? Colors.redAccent : Colors.grey[600]),
            )
          ],
        ),
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.live_tv,
                color: _displayPosts == 3 ? Colors.redAccent : Colors.grey[600],
              ),
              iconSize: 40.0,
              color: _displayPosts == 0 ? Colors.grey[300] : Colors.redAccent,
              onPressed: () => setState(() {
                _displayPosts = 3;
              }),
            ),
            Text(
              'Live Shows',
              style: TextStyle(
                  color:
                      _displayPosts == 3 ? Colors.redAccent : Colors.grey[600]),
            )
          ],
        ),
        Column(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.verified_user,
                  color:
                      _displayPosts == 4 ? Colors.redAccent : Colors.grey[600],
                ),
                iconSize: 40.0,
                color: _displayPosts == 0 ? Colors.grey[300] : Colors.white,
                onPressed: () {
                  //   setState(() {
                  //   _displayPosts = 4;
                  // });
                  if (widget.userId == widget.currentUserId) {
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    Builder(builder: (_) => snackBar);
                  }
                }),
            Text(
              'VIP',
              style: TextStyle(
                  color:
                      _displayPosts == 4 ? Colors.redAccent : Colors.grey[600]),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    usersRef.document(widget.userId).get();
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              ProfileScreenAppBar(
                user: user,
                isUser: _isUser,
              ),
              ProfileScreenInfo(
                currentUserId: widget.currentUserId,
                user: user,
                userId: widget.userId,
              ),
              _profileUser.stagesUser == true
                  ? _buildToggleButtons()
                  : Divider(color: Colors.white),
              _profileUser.stagesUser == true
                  ? SingleChildScrollView(child: _buildDisplayPosts())
                  : Divider(color: Colors.white),
            ],
          );
        },
      ),
      drawer: DrawerWidget(
        userId: widget.currentUserId,
      ),
    );
  }
}

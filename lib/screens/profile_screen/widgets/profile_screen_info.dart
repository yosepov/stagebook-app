import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/profile_screen/edit_profile_screen.dart';
import 'package:stagebook/screens/shop_screen/shop_screen.dart';
import 'package:stagebook/services/database_service.dart';

class ProfileScreenInfo extends StatefulWidget {
  final User user;
  final String currentUserId;
  final String userId;
  ProfileScreenInfo({this.user, this.currentUserId, this.userId});

  @override
  _ProfileScreenInfoState createState() => _ProfileScreenInfoState();
}

class _ProfileScreenInfoState extends State<ProfileScreenInfo> {
  bool _isSubscribing = false;
  int _subscriberCount = 0;
  int _starsCount = 0;
  int _subscribingCount = 0;
  List<Post> _posts = [];
  List<Lesson> _lessons = [];
  int _displayPosts = 0; // 0 - grid layout, 1 - column layout
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsSubscribing();
    _setupSubscribers();
    _setupSubscribing();
    _setupPosts();
    _setupProfileUser();
    _setupLessons();
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

  _selfSubscribe() {
    return;
  }

  _setupSubscribing() async {
    int userSubscribingCount =
        await DatabaseService.numSubscribers(widget.userId);
    setState(() {
      _subscribingCount = userSubscribingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _setupLessons() async {
    List<Lesson> lessons =
        await DatabaseService.getUserLessons(widget.user.companyId);
    setState(() {
      _lessons = lessons;
    });
    print(_lessons.length);
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

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId.uid
        ? Column(
            children: <Widget>[
              Container(
                width: 200.0,
                child: FlatButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        user: user,
                      ),
                    ),
                  ),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Container(
                width: 200.0,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ShopScreen.id,
                        arguments: {widget.currentUserId, widget.userId});
                  },
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  child: Text(
                    'Shop',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            width: 200.0,
            child: widget.user.stagesUser == true
                ? FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ShopScreen.id,
                          arguments: {widget.currentUserId, widget.userId});
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: Text(
                      'Shop',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25.0,
        ),
        GFAvatar(
          radius: 150,
          shape: GFAvatarShape.standard,
          backgroundColor: Colors.red,
          backgroundImage: widget.user.profileImageUrl == null
              ? AssetImage('assets/images/placeholder_profile_image.png')
              : CachedNetworkImageProvider(widget.user.profileImageUrl),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            widget.user.stagesUser == true
                                ? Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.slideshow),
                                        onPressed: () {},
                                        color: _isSubscribing ||
                                                widget.userId ==
                                                    Provider.of<UserData>(
                                                            context)
                                                        .currentUserId
                                                        .uid
                                            ? Colors.blue
                                            : Colors.red[200],
                                      ),
                                      Text(
                                        _lessons.length.toString(),
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Videos',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.album),
                                  onPressed: () {},
                                  color: _isSubscribing ||
                                          widget.userId ==
                                              Provider.of<UserData>(context)
                                                  .currentUserId
                                                  .uid
                                      ? Colors.redAccent
                                      : Colors.red[200],
                                ),
                                Text(
                                  _posts.length.toString(),
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'posts',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.view_agenda),
                                  onPressed: widget.userId ==
                                          Provider.of<UserData>(context)
                                              .currentUserId
                                              .uid
                                      ? _selfSubscribe
                                      : _subscribeOrUnsubscribe,
                                  color: _isSubscribing ||
                                          widget.userId ==
                                              Provider.of<UserData>(context)
                                                  .currentUserId
                                                  .uid
                                      ? Colors.redAccent
                                      : Colors.red[200],
                                ),
                                Text(
                                  '${_subscriberCount.toString()}',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'subscribers',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        _displayButton(widget.user),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Divider(
                    color: Colors.redAccent,
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.user.recordLabel == null
                          ? ''
                          : '${widget.user.recordLabel}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      widget.user.fullName,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 80.0,
                      child: Text(
                        widget.user.bio,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/activity_screen/activities_screen.dart';
import 'package:stagebook/screens/profile_screen/profile_screen.dart';
import 'package:stagebook/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserData>(context).currentUserId.uid;

    return Scaffold(
      body: FutureBuilder(
          future: DatabaseService.getUserWithId(currentUserId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User thisUser = snapshot.data;
            return PageView(
              controller: _pageController,
              children: <Widget>[
                // FeedScreen(
                //   currentUserId: currentUserId,
                // ),
                // CreateLiveShowScreen(),
                // MainHomePageScreen(
                //   currentUserId: currentUserId,
                //   userId: currentUserId,
                // ),

                ProfileScreen(
                  currentUserId: currentUserId,
                  userId: thisUser.companyId,
                ),
                ActivityScreen(
                  currentUserId: currentUserId,
                ),
                ProfileScreen(
                  currentUserId: currentUserId,
                  userId: currentUserId,
                ),
              ],
              onPageChanged: (int index) {
                setState(() {
                  _currentTab = index;
                });
              },
            );
          }),
    );
  }
}

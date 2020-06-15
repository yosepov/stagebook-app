import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/screens/add_new_product_screen/add_product_screen.dart';
import 'package:stagebook/screens/create_post_screen/create_liveshow_post_screen.dart';
import 'package:stagebook/screens/create_post_screen/create_post_screen.dart';
import 'package:stagebook/screens/create_show_screen/create_Show_screen.dart';
import 'package:stagebook/screens/feed_screen/feed_screen.dart';
import 'package:stagebook/screens/feed_screen/widgets/search_screen.dart';
import 'package:stagebook/screens/home_screen/home_screen.dart';
import 'package:stagebook/screens/lessons_screen/create_lesson.dart';
import 'package:stagebook/screens/login_screen/login_Screen.dart';
import 'package:stagebook/screens/menu_screen/main_menu_screen.dart';
import 'package:stagebook/screens/shop_screen/shop_screen.dart';
import 'package:stagebook/services/auth_service.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/services/storage_service.dart';

import 'models/user_data.dart';

void main() => runApp(
      //provide if user data
      MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
      ], child: MyApp()),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STAGES',
      //remove debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: StreamBuilder<FirebaseUser>(
        //listtening to:
        stream: Provider.of<AuthService>(context, listen: false).user,

        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //check if the user is logged in to navigate the right screen
          //store the user data at our provider everytime he s log in
          Provider.of<UserData>(context, listen: false).currentUserId =
              snapshot.data;
          if (snapshot.hasData) {
            //if logged in

            return HomeScreen();
          } else {
            //if the user is logged out
            return LoginScreen();
          }
        },
      ),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        CreatePostScreen.id: (context) => CreatePostScreen(),
        CreateLiveShowPostScreen.id: (context) => CreateLiveShowPostScreen(),
        MainMenuScreen.id: (context) => MainMenuScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        FeedScreen.id: (context) => FeedScreen(),
        CreateLessonScreen.id: (context) => CreateLessonScreen(),
        CreateShowScreen.id: (context) => CreateShowScreen(),
        AddProductScreen.id: (context) => AddProductScreen(),
        ShopScreen.id: (context) => ShopScreen(),
      },
    );
  }
}

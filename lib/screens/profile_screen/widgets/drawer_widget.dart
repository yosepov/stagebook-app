import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/profile_screen/edit_profile_screen.dart';
import 'package:stagebook/services/auth_service.dart';
import 'package:stagebook/utilities.dart/constants.dart';

class DrawerWidget extends StatefulWidget {
  String userId;

  DrawerWidget({this.userId});
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: usersRef.document(widget.userId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]),
            ),
          );
        }
        User user = User.fromDoc(snapshot.data);

        return Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  user.fullName == null ? '' : user.fullName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  user.email == null ? '' : user.email,
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        user.profileImageUrl != null
                            ? user.profileImageUrl
                            : 'assets/images/placeholder_profile_image.png'),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        'https://images.unsplash.com/photo-1533134486753-c833f0ed4866?ixlib=rb-1.2.1&dpr=1&auto=format&fit=crop&w=416&h=312&q=60'),
                  ),
                ),
              ),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
                      user: user,
                    ),
                  ),
                ),
                title: Text('Edit Profile'),
                trailing: Icon(
                  Icons.edit,
                ),
              ),
              ListTile(
                title: Text('Account Settings'),
                trailing: Icon(
                  Icons.settings,
                ),
              ),
              ListTile(
                title: Text('Wallet Settings'),
                trailing: Icon(
                  Icons.account_balance_wallet,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                title: Text('Privacy Policy'),
                trailing: Icon(
                  Icons.dock,
                ),
              ),
              ListTile(
                title: Text('Terms'),
                trailing: Icon(
                  Icons.verified_user,
                ),
              ),
              ListTile(
                title: Text('Security'),
                trailing: Icon(
                  Icons.security,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                title: Text('Hiring'),
                trailing: Icon(
                  Icons.work,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                onTap: () => authService.logout(),
                title: Text('Logout'),
                trailing: Icon(
                  Icons.exit_to_app,
                ),
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                title: Text('close'),
                trailing: Icon(
                  Icons.close,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }
}

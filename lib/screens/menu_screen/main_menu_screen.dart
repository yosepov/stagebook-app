import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  static final String id = "mainMenu_screen";

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                
                child: FlatButton(
                  child: Text(
                    'Profile settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
              GestureDetector(
                child: FlatButton(
                  child: Text(
                    'account settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
                onTap: () => {},
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

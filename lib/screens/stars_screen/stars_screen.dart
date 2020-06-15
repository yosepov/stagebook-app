import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/screens/feed_screen/widgets/search_screen.dart';
import 'package:stagebook/services/auth_service.dart';

class StarsScreen extends StatefulWidget {
  @override
  _StarsScreenState createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.new_releases),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        title: Row(
          children: <Widget>[
            Text(
              'Live Shows',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Omer Adam',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: Text(
                    'watch Live',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image(
            image: NetworkImage(
                'https://yt3.ggpht.com/onsr4kenxu9uhadpr4-vW57krT0BoyaTdRP1L4_0L1qesrMY285ArTBfcCtfQFzoMiMMgSwdpMo=w2560-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj'),
          ),
          Divider(
            color: Colors.red,
            height: 30,
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Shlomi Shabat',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: Text(
                    'watch Live',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image(
            image: NetworkImage(
                'https://d3svuw7u2wrei6.cloudfront.net/2207/wp-content/uploads/2017/10/14165001/%D7%A9%D7%9C%D7%95%D7%9E%D7%99-%D7%A9%D7%91%D7%AA-%D7%91%D7%90%D7%A0%D7%A8.jpg'),
          ),
          Divider(
            color: Colors.red,
            height: 30,
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Lior Sushard',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: Text(
                    'watch Live',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image(
            image: NetworkImage(
                'https://d3svuw7u2wrei6.cloudfront.net/2207/wp-content/uploads/2019/02/27182304/%D7%91%D7%90%D7%A0%D7%A8-%D7%A7%D7%98%D7%9F.jpg'),
          ),
          Divider(
            color: Colors.red,
            height: 30,
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Noa Kirel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: Text(
                    'watch Live',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image(
            image: NetworkImage(
                'https://d3svuw7u2wrei6.cloudfront.net/2207/wp-content/uploads/2019/06/31124618/%D7%A0%D7%95%D7%A2%D7%94-%D7%A7%D7%99%D7%A8%D7%9C-%D7%94%D7%95%D7%A4%D7%A2%D7%94.jpg'),
          ),
          Divider(
            color: Colors.red,
            height: 30,
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Shlomo Artzi',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: Text(
                    'watch Live',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image(
            image: NetworkImage(
                'https://d3svuw7u2wrei6.cloudfront.net/haifa/wp-content/uploads/2018/12/10151440/%D7%91%D7%90%D7%A0%D7%A8-%D7%9C%D7%90%D7%AA%D7%A8-2-1024x300.jpg'),
          ),
          Divider(
            color: Colors.red,
            height: 30,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}

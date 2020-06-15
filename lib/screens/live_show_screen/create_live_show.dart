import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/live_show_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/services/database_service.dart';

class CreateLiveShowScreen extends StatefulWidget {
  static final String id = "createliveShow_screen";

  @override
  _CreateLiveShowScreenState createState() => _CreateLiveShowScreenState();
}

class _CreateLiveShowScreenState extends State<CreateLiveShowScreen> {
  String _youtubeUrl;
  String _liveShowTitle;
  String _description;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController __youtubeUrlController = TextEditingController();
  TextEditingController _liveShowTitleController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  bool _isLive;
  int _cost;
  TextEditingController _dateTimeController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  final DateFormat _dateTimeFormatter = DateFormat('MM/dd/yyyy , HH,mm');

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020, 1, 0),
      lastDate: DateTime(2100, 1, 0),
    );

    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
      //date format
      _dateTimeController.text = _dateTimeFormatter.format(date);
    }
  }

  _submit() async {
    //create the post
    LiveShow liveShow = LiveShow(
      youtubeUrl: _youtubeUrl,
      description: _description,
      liveShowTitle: _liveShowTitle,
      starCount: 0,
      authorId: Provider.of<UserData>(context, listen: false).currentUserId.uid,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );

    DatabaseService.createLiveShow(liveShow);

    //reset our data
    _descriptionController.clear();
    _costController.clear();
    __youtubeUrlController.clear();
    _liveShowTitleController.clear();
    setState(() {
      _description = '';
      _isLive = false;
      _liveShowTitle = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Upload a liveShow',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Upload The Live Show Through Youtube',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _descriptionController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (input) => _description = input,
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: __youtubeUrlController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(labelText: 'youtube Url'),
                onChanged: (input) => _youtubeUrl = input,
              ),
            ),
            Text('please make sure that the LiveShow is unlisted'),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _liveShowTitleController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (input) => _liveShowTitle = input,
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: FlatButton(
                onPressed: () {
                  if (_isLive == false) {
                    setState(() {
                      _isLive = true;
                    });
                  } else {
                    setState(() {
                      _isLive = false;
                    });
                  }
                },
                child: Text(_isLive == false ? 'Not Live' : 'Is Live'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                readOnly: true,
                controller: _dateTimeController,
                onTap: _handleDatePicker,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Date',
                  hasFloatingPlaceholder: true,
                  hoverColor: Colors.redAccent,
                  icon: Icon(Icons.access_time),
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.redAccent,
              iconSize: 30,
              onPressed: () => _submit(),
            ),
            Text('add your post'),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/services/storage_service.dart';

class CreateLessonScreen extends StatefulWidget {
  static final String id = "createlesson_screen";

  @override
  _CreateLessonScreenState createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  String _youtubeUrl;
  File _image;
  bool _isLoading = false;
  String _lessonTitle;
  String _description;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController __youtubeUrlController = TextEditingController();
  TextEditingController _lessonTitleController = TextEditingController();
  bool _isLive;
  final _addLessonFormKey = GlobalKey<FormState>();

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add post file'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose from gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    print('android');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add post file'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take a Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose from gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      // crop the image --> flutter bug - needs update
      // imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _buildLessonTitleTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (input) => input.length < 1 || input.length > 21
            ? 'Please enter title under 21 digits'
            : null,
        onSaved: (input) => _lessonTitle,
        controller: _lessonTitleController,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'Title',
        ),
        onChanged: (input) => _lessonTitle = input,
      ),
    );
  }

  _buildYoutubeUrlTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter your youtube video Url' : null,
        onSaved: (input) => _youtubeUrl = input.trim(),
        controller: __youtubeUrlController,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'https://www.youtube.com/watch?v=VidID',
        ),
        onChanged: (input) => _youtubeUrl = input,
      ),
    );
  }

  _buildDescriptionTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (input) =>
            input.length > 300 ? 'Must be under 300 characters' : null,
        controller: _descriptionController,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(labelText: 'Description'),
        onChanged: (input) => _description = input,
      ),
    );
  }

  _submit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_addLessonFormKey.currentState.validate() && _image != null) {
        //create the post
        String imageUrl = await StorageService.uploadProductImage(_image);

        Lesson lesson = Lesson(
          youtubeUrl: _youtubeUrl,
          description: _description,
          lessonTitle: _lessonTitle,
          starCount: 0,
          imageUrl: imageUrl,
          isLive: _isLive,
          authorId:
              Provider.of<UserData>(context, listen: false).currentUserId.uid,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        DatabaseService.createLesson(lesson);

        // //reset our data
        // _descriptionController.clear();
        // __youtubeUrlController.clear();
        // _lessonTitleController.clear();
        // setState(() {
        //   _description = '';
        //   _isLive = false;
        //   _lessonTitle = '';
        // });
        print(_youtubeUrl);
        setState(() {
          _lessonTitle = '';
          _image = null;
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Upload a lesson',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addLessonFormKey,
          child: Column(
            children: <Widget>[
              _isLoading
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.blue[200],
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    )
                  : SizedBox.shrink(),
              GestureDetector(
                onTap: _showSelectImageDialog,
                child: Container(
                  height: width,
                  width: width,
                  color: Colors.grey[300],
                  child: _image == null
                      ? Icon(Icons.add_a_photo,
                          color: Colors.redAccent, size: 150.0)
                      : Image(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  'Upload your lesson video to Youtube',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              _buildYoutubeUrlTF(),
              Text(
                ' unlisted videos are reccomended.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Click here to know why',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(height: 10.0),
              _buildLessonTitleTF(),
              SizedBox(height: 10.0),
              _buildDescriptionTF(),
              SizedBox(height: 10.0),
              SizedBox(height: 10.0),
              SizedBox(height: 10.0),
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Need Help Uploading a lesson?',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(height: 10.0),
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Get Some Tips!',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.redAccent,
                iconSize: 30,
                onPressed: () => _submit(),
              ),
              Text("Add Your Video"),
            ],
          ),
        ),
      ),
    );
  }
}

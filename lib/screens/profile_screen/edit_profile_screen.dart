import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name, _bio, _nickname, _recordLabel = '';
  DateTime _birthDate;
  bool _isLoading = false;
  bool _stagesUser = false;
  bool changeProfileImage = false;
  TextEditingController _birthDateController = TextEditingController();

  final DateFormat _birthDateFormatter = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    _name = widget.user.fullName;
    _bio = widget.user.bio;
    _nickname = widget.user.nickname;
    _recordLabel = widget.user.recordLabel;
    _stagesUser = widget.user.stagesUser;
    _birthDate = widget.user.birthDate.toDate();
    // fixing the current date bug that dosent apear beacuse of the validate at _handleDatePicker function

    _birthDateController.text = _birthDateFormatter.format(_birthDate);
  }

  _handleImageFromGallary() async {
    changeProfileImage = true;
    File imageFile;
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    //no new prfile image
    if (_profileImage == null) {
      //no exsiting profile image
      if (widget.user.profileImageUrl == null) {
        //display placeholder
        return AssetImage('assets/images/placeholder_profile_image.png');
      } else {
        //if the user profile image already exsits
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      //new profile image
      return FileImage(_profileImage);
    }
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2007),
    );

    if (date != null && date != _birthDate) {
      setState(() {
        _birthDate = date;
      });
      //date format
      _birthDateController.text = _birthDateFormatter.format(date);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      //update user at the database
      String _profileImageUrl;

      setState(() {
        _isLoading = true;
      });

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        if (changeProfileImage) {
          _profileImageUrl = await StorageService.uploadUserProfileImage(
              widget.user.profileImageUrl, _profileImage);
        }
      }

      User user = User(
        id: widget.user.id,
        fullName: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
        stagesUser: _stagesUser,
        birthDate: Timestamp.fromDate(_birthDate),
        recordLabel: _recordLabel,
        nickname: _nickname,
      );
      print(user.stagesUser);
      // database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.redAccent,
                    valueColor: AlwaysStoppedAnimation(Colors.redAccent))
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: () => _handleImageFromGallary(),
                      child: Text(
                        'Upload profile image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (input) => input.trim().length < 1
                          ? 'please enter a valid name'
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: _birthDateController,
                        onTap: _handleDatePicker,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Birth Date',
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
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30.0,
                        ),
                        labelText: 'Bio',
                      ),
                      validator: (input) => input.trim().length > 150
                          ? 'please enter a bio less than 150 charecters'
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {},
                                child: Text('STAGES USER'),
                                onLongPress: () {
                                  setState(() {
                                    _stagesUser = true;
                                  });
                                },
                                color: _stagesUser == true
                                    ? Colors.redAccent
                                    : Colors.white,
                                textColor: _stagesUser == true
                                    ? Colors.white
                                    : Colors.redAccent,
                              ),
                              FlatButton(
                                child: Text('Normal USER'),
                                onPressed: () {
                                  setState(() {
                                    if (_stagesUser != false) {
                                      _stagesUser = false;
                                    }
                                  });
                                },
                                color: _stagesUser == false
                                    ? Colors.redAccent
                                    : Colors.white,
                                textColor: _stagesUser == false
                                    ? Colors.white
                                    : Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widget.user.stagesUser == true
                        ? Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: _nickname,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.star,
                                    size: 30.0,
                                  ),
                                  labelText: 'Stage Nickname',
                                ),
                                validator: (input) => input.trim().length > 150
                                    ? 'please enter a Stage nickname'
                                    : null,
                                onSaved: (input) => _nickname = input,
                              ),
                              TextFormField(
                                initialValue: _recordLabel,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.label,
                                    size: 30.0,
                                  ),
                                  labelText: 'Record Label',
                                ),
                                validator: (input) => input.trim().length > 150
                                    ? 'please enter a Record Label name'
                                    : null,
                                onSaved: (input) => _recordLabel = input,
                              ),
                            ],
                          )
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text(
                          'save',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

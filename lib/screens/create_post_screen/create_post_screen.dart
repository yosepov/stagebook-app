import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/services/storage_service.dart';

class CreatePostScreen extends StatefulWidget {
  static final String id = "createpost_screen";

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  File _video;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  final _flutterVideoCompress = FlutterVideoCompress();
  Uint8List _imageVideo;
  Subscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

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

  _handleVideo(ImageSource source) async {
    Navigator.pop(context);
    File videoFile = await ImagePicker.pickVideo(source: source);
    if (videoFile != null) {
      setState(() {
        _video = videoFile;
      });
    }
  }

  // crop the image function --> flutter bug - needs update

  // _cropImage(File imageFile) async {
  //   File croppedImage = await ImageCropper.cropImage(
  //     sourcePath: imageFile.path,
  //     aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
  //   );
  //   return croppedImage;
  // }

  _submit() async {
    if (!_isLoading &&
        (_image != null || _video != null) &&
        _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      //create the post
      if (_image != null) {
        String imageUrl = await StorageService.uploadImagePost(_image);
        Post post = Post(
          imageUrl: imageUrl,
          caption: _caption,
          starCount: 0,
          video: false,
          authorId:
              Provider.of<UserData>(context, listen: false).currentUserId.uid,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        DatabaseService.createImagePost(post);
      } else if (_video != null) {
        String videoUrl = await StorageService.uploadVideoPost(_video);
        String videoThumbnailUrl =
            await StorageService.uploadVideoThumbnailPost(_video);

        Post post = Post(
          imageUrl: videoUrl,
          thumbnail: videoThumbnailUrl,
          caption: _caption,
          starCount: 0,
          video: true,
          authorId:
              Provider.of<UserData>(context, listen: false).currentUserId.uid,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        DatabaseService.createVideoPost(post);
      }

      //reset our data
      _captionController.clear();
      setState(() {
        _caption = '';
        _image = null;
        _video = null;
        _isLoading = false;
      });
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
          'Upload a Photo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
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
                        ? _video == null
                            ? Icon(Icons.add_a_photo,
                                color: Colors.redAccent, size: 150.0)
                            : Icon(Icons.videocam,
                                color: Colors.redAccent, size: 150.0)
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(labelText: 'Write Something'),
                    onChanged: (input) => _caption = input,
                  ),
                ),
                Text(
                  'Tip: Be as Authentic As Possible',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10.0),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'How to make it perfect?',
                    style: TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

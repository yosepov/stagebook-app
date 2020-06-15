// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:stagebook/models/product_model.dart';
// import 'package:stagebook/models/user_data.dart';
// import 'package:stagebook/services/database_service.dart';
// import 'package:stagebook/services/storage_service.dart';

// class AddProductScreen extends StatefulWidget {
//   @override
//   static final String id = "addproductscreen_screen";

//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   File _image;
//   final DateFormat _dateTimeFormatter = DateFormat('MM/dd/yyyy');
//   TextEditingController _dateTimeController = TextEditingController();
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _costController = TextEditingController();
//   TextEditingController _saleController = TextEditingController();
//   String _title = '';
//   int _cost = 0;
//   int _sale = 0;
//   DateTime _dateTime = DateTime.now();
//   bool _isLoading = false;
//   final _flutterVideoCompress = FlutterVideoCompress();
//   Uint8List _imageVideo;
//   Subscription _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _subscription =
//         _flutterVideoCompress.compressProgress$.subscribe((progress) {
//       debugPrint('progress: $progress');
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _subscription.unsubscribe();
//   }

//   _showSelectImageDialog() {
//     return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
//   }

//   _iosBottomSheet() {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoActionSheet(
//             title: Text('Add Photo'),
//             actions: <Widget>[
//               CupertinoActionSheetAction(
//                 child: Text('Take Photo'),
//                 onPressed: () => _handleImage(ImageSource.camera),
//               ),
//               CupertinoActionSheetAction(
//                 child: Text('Choose a photo from gallery'),
//                 onPressed: () => _handleImage(ImageSource.gallery),
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               child: Text('Cancel'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           );
//         });
//   }

//   _androidDialog() {
//     print('android');
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return SimpleDialog(
//             title: Text('Add a Photo'),
//             children: <Widget>[
//               SimpleDialogOption(
//                 child: Text('Take a Photo'),
//                 onPressed: () => _handleImage(ImageSource.camera),
//               ),
//               SimpleDialogOption(
//                 child: Text('Choose a photo from gallery'),
//                 onPressed: () => _handleImage(ImageSource.gallery),
//               ),
//               SimpleDialogOption(
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.redAccent),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           );
//         });
//   }

//   _handleImage(ImageSource source) async {
//     Navigator.pop(context);
//     File imageFile = await ImagePicker.pickImage(source: source);
//     if (imageFile != null) {
//       // crop the image --> flutter bug - needs update
//       // imageFile = await _cropImage(imageFile);
//       setState(() {
//         _image = imageFile;
//       });
//     }
//   }

//   // crop the image function --> flutter bug - needs update

//   // _cropImage(File imageFile) async {
//   //   File croppedImage = await ImageCropper.cropImage(
//   //     sourcePath: imageFile.path,
//   //     aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
//   //   );
//   //   return croppedImage;
//   // }

//   _submit() async {
//     if (!_isLoading && (_image != null) && _title.isNotEmpty) {
//       setState(() {
//         _isLoading = true;
//       });
//       if (_image != null) {
//         //create the post
//         String imageUrl = await StorageService.uploadImageOfNewProduct(_image);

//         // database update
//         ProductModel product = ProductModel(
//           imageUrl: imageUrl,
//           title: _title,
//           cost: _cost,
//           shopId:
//               Provider.of<UserData>(context, listen: false).currentUserId.uid,
//           timestamp: Timestamp.fromDate(DateTime.now()),
//         );

//         DatabaseService.createNewProduct(product);
//       }

//       //reset our data
//       _titleController.clear();
//       _costController.clear();
//       _saleController.clear();
//       _dateTimeController.clear();
//       setState(() {
//         _title = '';
//         _image = null;
//         _isLoading = false;
//         _cost = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           child: Container(
//             height: height,
//             child: Column(
//               children: <Widget>[
//                 _isLoading
//                     ? Padding(
//                         padding: EdgeInsets.only(bottom: 10.0),
//                         child: LinearProgressIndicator(
//                           backgroundColor: Colors.yellow[200],
//                           valueColor: AlwaysStoppedAnimation(Colors.yellow),
//                         ),
//                       )
//                     : SizedBox.shrink(),
//                 GestureDetector(
//                   onTap: _showSelectImageDialog,
//                   child: Container(
//                     height: width,
//                     width: width,
//                     color: Colors.grey[300],
//                     child: Image(
//                       image: FileImage(_image),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   child: Column(
//                     children: <Widget>[
//                       TextField(
//                         controller: _titleController,
//                         style: TextStyle(fontSize: 18.0),
//                         decoration: InputDecoration(labelText: 'title'),
//                         onChanged: (input) => _title = input,
//                       ),
//                       TextField(
//                         controller: _costController,
//                         style: TextStyle(fontSize: 18.0),
//                         decoration: InputDecoration(labelText: 'cost'),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           WhitelistingTextInputFormatter.digitsOnly
//                         ], // Only numbers can be entered
//                         onChanged: (input) => _cost = num.tryParse(input),
//                       ),
//                       TextField(
//                         controller: _saleController,
//                         style: TextStyle(fontSize: 18.0),
//                         decoration: InputDecoration(labelText: 'cost'),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           WhitelistingTextInputFormatter.digitsOnly
//                         ], // Only numbers can be entered
//                         onChanged: (input) => _sale = num.tryParse(input),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   color: Colors.redAccent,
//                   iconSize: 30,
//                   onPressed: () => _submit(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/product_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/services/storage_service.dart';

class AddProductScreen extends StatefulWidget {
  static final String id = "addproductscreen_screen";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File _image;
  File _video;
  final DateFormat _dateTimeFormatter = DateFormat('MM/dd/yyyy');
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _saleController = TextEditingController();
  String _title = '';
  String _description = '';
  int _cost = 0;
  int _sale = 0;
  DateTime _dateTime = DateTime.now();
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

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
      //date format
      _dateTimeController.text = _dateTimeFormatter.format(date);
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

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose a photo from gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose a video from gallery'),
                onPressed: () => _handleVideo(ImageSource.gallery),
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
            title: Text('Add a Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take a Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose a photo from gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text('take a video'),
                onPressed: () => _handleVideo(ImageSource.camera),
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
        _title.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      if (_image != null) {
        //create the post
        String imageUrl = await StorageService.uploadImageOfNewProduct(_image);

        // database update
        ProductModel product = ProductModel(
          imageUrl: imageUrl,
          title: _title,
          description: _description,
          cost: _cost,
          sale: _sale,
          shopId:
              Provider.of<UserData>(context, listen: false).currentUserId.uid,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        DatabaseService.createNewProduct(product);
      }

      //reset our data
      _titleController.clear();
      _descriptionController.clear();
      _costController.clear();
      _saleController.clear();
      _dateTimeController.clear();
      setState(() {
        _title = '';
        _description = '';
        _image = null;
        _isLoading = false;
        _cost = 0;
        _sale = 0;
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
          'Add new Product',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[],
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
                          backgroundColor: Colors.yellow[200],
                          valueColor: AlwaysStoppedAnimation(Colors.yellow),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: 200,
                    width: width,
                    color: Colors.grey[300],
                    child: _image == null
                        ? _video == null
                            ? Icon(Icons.add_a_photo,
                                color: Colors.white70, size: 150.0)
                            : Icon(Icons.videocam,
                                color: Colors.white70, size: 150.0)
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _titleController,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (input) => _title = input,
                      ),
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (input) => _description = input,
                      ),
                      TextField(
                        controller: _costController,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(labelText: 'Cost'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        onChanged: (input) => _cost = num.tryParse(input),
                      ),
                      TextField(
                        controller: _saleController,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                            labelText: 'Sale - Zero (0) for cancel'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        onChanged: (input) => _sale = num.tryParse(input),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.redAccent,
                  iconSize: 30,
                  onPressed: () => _submit(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

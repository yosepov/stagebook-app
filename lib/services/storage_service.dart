import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stagebook/utilities.dart/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    if (url != null) {
      // Updating user profile image
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }

    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadUserLastImage(String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    if (url != null) {
      // Updating user profile image
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }

    StorageUploadTask uploadTask =
        storageRef.child('images/users/userPosts_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

  static Future<String> uploadImagePost(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask =
        storageRef.child('images/posts/post_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadProductImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask =
        storageRef.child('images/products/product_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadImageLiveShowPost(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask = storageRef
        .child('images/liveshowposts/post_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadImageOfNewProduct(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask =
        storageRef.child('images/products/product_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadLiveShowVideoPost(File videoFile) async {
    final _flutterVideoCompress = FlutterVideoCompress();
    String videoId = Uuid().v4();
    final MediaInfo info = await _flutterVideoCompress.compressVideo(
      videoFile.path,
      deleteOrigin: false,
      quality: VideoQuality.DefaultQuality,
    );
    print(info.toJson().toString());

    File resultFile = await _flutterVideoCompress.getThumbnailWithFile(
      videoFile.absolute.path,
      quality: 50,
      position: -1,
    );
    assert(resultFile.existsSync());

    print(info.toJson().toString());
    _flutterVideoCompress.compressProgress$.subscribe((progress) {
      print('progress: $progress');
    });

    StorageUploadTask uploadTask = storageRef
        .child('videos/liveShows/post_$videoId.mp4')
        .putFile(videoFile, StorageMetadata(contentType: 'video/mp4'));

    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadVideoPost(File videoFile) async {
    final _flutterVideoCompress = FlutterVideoCompress();
    String videoId = Uuid().v4();
    final MediaInfo info = await _flutterVideoCompress.compressVideo(
      videoFile.path,
      deleteOrigin: false,
      quality: VideoQuality.DefaultQuality,
    );
    print(info.toJson().toString());

    File resultFile = await _flutterVideoCompress.getThumbnailWithFile(
      videoFile.absolute.path,
      quality: 50,
      position: -1,
    );
    assert(resultFile.existsSync());

    print(info.toJson().toString());
    _flutterVideoCompress.compressProgress$.subscribe((progress) {
      print('progress: $progress');
    });

    StorageUploadTask uploadTask = storageRef
        .child('videos/posts/post_$videoId.mp4')
        .putFile(videoFile, StorageMetadata(contentType: 'video/mp4'));

    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadVideoThumbnailPost(File videoFile) async {
    final _flutterVideoCompress = FlutterVideoCompress();
    String videoId = Uuid().v4();
    final MediaInfo info = await _flutterVideoCompress.compressVideo(
      videoFile.path,
      deleteOrigin: false,
      quality: VideoQuality.DefaultQuality,
    );
    print(info.toJson().toString());

    File resultFile = await _flutterVideoCompress.getThumbnailWithFile(
      videoFile.absolute.path,
      quality: 50,
      position: -1,
    );
    assert(resultFile.existsSync());

    print(info.toJson().toString());
    _flutterVideoCompress.compressProgress$.subscribe((progress) {
      print('progress: $progress');
    });

    StorageUploadTask uploadTask = storageRef
        .child('images/postsVideos/post_$videoId.jpg')
        .putFile(resultFile);

    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
}

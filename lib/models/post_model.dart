
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String userId;
  final String thumbnail;
  final String caption;
  final int starCount;
  final String authorId;
  final Timestamp timestamp;
  final bool video;

  Post(
      {this.id,
      this.authorId,
      this.userId,
      this.thumbnail,
      this.caption,
      this.imageUrl,
      this.starCount,
      this.timestamp,
      this.video,});

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      thumbnail: doc['thumbnail'],
      userId: doc['userId'],
      caption: doc['caption'],
      starCount: doc['starCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      video: doc['video'],
    );
  }
}

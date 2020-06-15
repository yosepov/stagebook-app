import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String postId;
  final String lessonId;
  final String comment;
  final String postImageUrl;
  final String youtubeUrl;
  final String fromUserId;
  final Timestamp timestamp;

  Activity(
      {this.id,
      this.fromUserId,
      this.postId,
      this.lessonId,
      this.timestamp,
      this.youtubeUrl,
      this.comment,
      this.postImageUrl});

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.documentID,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      lessonId: doc['lessonId'],
      postImageUrl: doc['postImageUrl'],
      youtubeUrl: doc['youtubeUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final String youtubeUrl;
  final String imageUrl;
  final String lessonTitle;
  final String description;
  final int starCount;
  final String authorId;
  final Timestamp dateTime;
  final Timestamp timestamp;
  final bool isLive;

  Lesson(
      {this.id,
      this.dateTime,
      this.isLive,
      this.imageUrl,
      this.authorId,
      this.description,
      this.youtubeUrl,
      this.lessonTitle,
      this.starCount,
      this.timestamp});

  factory Lesson.fromDoc(DocumentSnapshot doc) {
    return Lesson(
      id: doc.documentID,
      youtubeUrl: doc['youtubeUrl'],
      lessonTitle: doc['lessonTitle'],
      imageUrl: doc['imageUrl'],
      isLive: doc['isLive'],
      description: doc['description'],
      dateTime: doc['dateTime'],
      starCount: doc['starCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}

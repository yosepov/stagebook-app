import 'package:cloud_firestore/cloud_firestore.dart';

class LiveShow {
  final String id;
  final String youtubeUrl;
  final String liveShowTitle;
  final String description;
  final int starCount;
  final int cost;
  final String authorId;
  final Timestamp dateTime;
  final Timestamp timestamp;
  final bool isLive;

  LiveShow(
      {this.id,
      this.dateTime,
      this.isLive,
      this.cost,
      this.authorId,
      this.description,
      this.youtubeUrl,
      this.liveShowTitle,
      this.starCount,
      this.timestamp});

  factory LiveShow.fromDoc(DocumentSnapshot doc) {
    return LiveShow(
      id: doc.documentID,
      youtubeUrl: doc['youtubeUrl'],
      liveShowTitle: doc['liveShowTitle'],
      isLive: doc['isLive'],
      cost: doc['cost'],
      description: doc['description'],
      dateTime: doc['dateTime'],
      starCount: doc['starCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}

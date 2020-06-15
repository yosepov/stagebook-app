import 'package:cloud_firestore/cloud_firestore.dart';

class LiveShowPost {
  final String id;
  final String showId;
  final String imageUrl;
  final String thumbnail;
  final String caption;
  final int starCount;
  final String authorId;
  final Timestamp dateTime;
  final Timestamp timestamp;
  final String youtubeUrl;
  final int cost;
  final bool video;

  LiveShowPost(
      {this.id,
      this.showId,
      this.dateTime,
      this.video,
      this.cost,
      this.authorId,
      this.caption,
      this.imageUrl,
      this.youtubeUrl,
      this.thumbnail,
      this.starCount,
      this.timestamp});

  factory LiveShowPost.fromDoc(DocumentSnapshot doc) {
    return LiveShowPost(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      showId: doc['showId'],
      thumbnail: doc['thumbnail'],
      cost: doc['cost'],
      video: doc['video'],
      caption: doc['caption'],
      dateTime: doc['dateTime'],
      starCount: doc['starCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}

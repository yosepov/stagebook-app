import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String fullName;
  final String nickname;
  final String companyId;
  final String bio;
  final String profileImageUrl;
  final String lastPhoto;
  final String email;
  final String recordLabel;
  final bool stagesUser;
  final Timestamp birthDate;
  final int starsCount;

  User(
      {this.id,
      this.lastPhoto,
      this.companyId,
      this.fullName,
      this.starsCount,
      this.nickname,
      this.stagesUser,
      this.bio,
      this.profileImageUrl,
      this.email,
      this.recordLabel,
      this.birthDate});

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      fullName: doc['fullName'] ?? '',
      companyId: doc['companyId'] ?? '',
      birthDate: doc['birthDate'] ?? Timestamp.fromDate(DateTime(1971, 06, 28)),
      nickname: doc['nickname'],
      stagesUser: doc['stagesUser'] ?? false,
      bio: doc['bio'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      lastPhoto: doc['lastPhoto'],
      starsCount: doc['starsCount'],
      email: doc['email'],
      recordLabel: doc['recordLabel'],
    );
  }
}

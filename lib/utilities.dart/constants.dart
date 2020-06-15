import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final liveShowPostsRef = _firestore.collection('liveShowPosts');
final subscribersRef = _firestore.collection('subscribers');
final subscribingRef = _firestore.collection('subscribing');
final feedsRef = _firestore.collection('feeds');
final starsRef = _firestore.collection('stars');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');
final lessonsRef = _firestore.collection('lessons');
final liveShowsRef = _firestore.collection('liveShows');
final productsRef = _firestore.collection('products');

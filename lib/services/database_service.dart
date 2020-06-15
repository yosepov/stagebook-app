import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagebook/models/activity_model.dart';
import 'package:stagebook/models/lesson_model.dart';
import 'package:stagebook/models/live_show_model.dart';
import 'package:stagebook/models/live_show_post_model.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/product_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/utilities.dart/constants.dart';

class DatabaseService {
  Future<User> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return User.fromDoc(userDoc);
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        userPostsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<LiveShowPost>> getUserLiveShowPosts(String userId) async {
    QuerySnapshot userLiveShowPostsSnapshot = await liveShowPostsRef
        .document(userId)
        .collection('userLiveShowPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<LiveShowPost> liveShowPosts = userLiveShowPostsSnapshot.documents
        .map((doc) => LiveShowPost.fromDoc(doc))
        .toList();
    return liveShowPosts;
  }

  static Future<List<ProductModel>> getUserProducts(String shopId) async {
    QuerySnapshot userProductsSnapshot = await productsRef
        .document(shopId)
        .collection('userShopProducts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<ProductModel> products = userProductsSnapshot.documents
        .map((doc) => ProductModel.fromDoc(doc))
        .toList();
    return products;
  }

  static Future<List<Lesson>> getUserLessons(String userId) async {
    QuerySnapshot userLessonSnapShot = await lessonsRef
        .document(userId)
        .collection('userLessons')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Lesson> lessons =
        userLessonSnapShot.documents.map((doc) => Lesson.fromDoc(doc)).toList();
    return lessons;
  }

  static Future<List<LiveShow>> getUserLiveShows(String userId) async {
    QuerySnapshot userLiveShowSnapShot = await lessonsRef
        .document(userId)
        .collection('userLiveShows')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<LiveShow> liveShows = userLiveShowSnapShot.documents
        .map((doc) => LiveShow.fromDoc(doc))
        .toList();
    return liveShows;
  }

  static void starliveShowPost({String currentUserId, LiveShowPost post}) {
    DocumentReference liveShowPostRef = liveShowPostsRef
        .document(post.authorId)
        .collection('userLiveShowPosts')
        .document(post.id);
    liveShowPostRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      liveShowPostRef.updateData({'starCount': starCount + 1});
      starsRef
          .document(post.id)
          .collection('starCount')
          .document(currentUserId)
          .setData({});
    });
  }

  static void starPost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      postRef.updateData({'starCount': starCount + 1});
      starsRef
          .document(post.id)
          .collection('starCount')
          .document(currentUserId)
          .setData({});
      addActivityItem(currentUserId: currentUserId, post: post, comment: null);
    });
  }

  static void starLesson({String currentUserId, Lesson lesson}) {
    DocumentReference lessonRef = lessonsRef
        .document(lesson.authorId)
        .collection('userLessons')
        .document(lesson.id);
    lessonRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      lessonRef.updateData({'starCount': starCount + 1});
      starsRef
          .document(lesson.id)
          .collection('starCount')
          .document(currentUserId)
          .setData({});
    });
    addActivityItem(
        currentUserId: currentUserId, lesson: lesson, comment: null);
  }

  static void starLiveShow({String currentUserId, LiveShow liveShow}) {
    DocumentReference liveShowRef = liveShowsRef
        .document(liveShow.authorId)
        .collection('userLiveShows')
        .document(liveShow.id);
    liveShowRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      liveShowRef.updateData({'starCount': starCount + 1});
      starsRef
          .document(liveShow.id)
          .collection('liveShowStars')
          .document(currentUserId)
          .setData({});
    });
  }

  static void unstarPost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      postRef.updateData({'starCount': starCount - 1});
      starsRef
          .document(post.id)
          .collection('starCount')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static void unstarLesson({String currentUserId, Lesson lesson}) {
    DocumentReference lessonRef = lessonsRef
        .document(lesson.authorId)
        .collection('userLessons')
        .document(lesson.id);
    lessonRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      lessonRef.updateData({'starCount': starCount - 1});
      starsRef
          .document(lesson.id)
          .collection('starCount')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static void unstarLiveShow({String currentUserId, LiveShow liveShow}) {
    DocumentReference liveShowRef = liveShowsRef
        .document(liveShow.authorId)
        .collection('userLiveShows')
        .document(liveShow.id);
    liveShowRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      liveShowRef.updateData({'starCount': starCount - 1});
      starsRef
          .document(liveShow.id)
          .collection('liveShowStars')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static void unstarLiveShowPost({String currentUserId, LiveShowPost post}) {
    DocumentReference liveShowPostRef = liveShowPostsRef
        .document(post.authorId)
        .collection('userLiveShowPosts')
        .document(post.id);
    liveShowPostRef.get().then((doc) {
      int starCount = doc.data['starCount'];
      liveShowPostRef.updateData({'starCount': starCount - 1});
      starsRef
          .document(post.id)
          .collection('starCount')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<LiveShowPost>> getFeedLiveShowPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userLiveShowFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<LiveShowPost> liveShowPosts =
        feedSnapshot.documents.map((doc) => LiveShowPost.fromDoc(doc)).toList();
    return liveShowPosts;
  }

  static Future<bool> didStarLiveShowPost(
      {String currentUserId, LiveShowPost post}) async {
    DocumentSnapshot userDoc = await starsRef
        .document(post.id)
        .collection('starCount')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static Future<bool> didStarPost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await starsRef
        .document(post.id)
        .collection('starCount')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static Future<bool> didStarLesson(
      {String currentUserId, Lesson lesson}) async {
    DocumentSnapshot userDoc = await starsRef
        .document(lesson.id)
        .collection('starCount')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static Future<bool> didStarLiveShow(
      {String currentUserId, LiveShow liveShow}) async {
    DocumentSnapshot userDoc = await starsRef
        .document(liveShow.id)
        .collection('liveShowStars')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void commentOnPost({String currentUserId, Post post, String comment}) {
    commentsRef.document(post.id).collection('postComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityItem(currentUserId: currentUserId, post: post, comment: comment);
  }

  static void commentOnLesson(
      {String currentUserId, Lesson lesson, String comment}) {
    commentsRef.document(lesson.id).collection('lessonComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    addActivityItem(
        currentUserId: currentUserId, lesson: lesson, comment: comment);
  }

  static void commentOnLiveShow(
      {String currentUserId, LiveShow liveShow, String comment}) {
    commentsRef.document(liveShow.id).collection('liveShowComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  static void commentOnLiveShowPost(
      {String currentUserId, LiveShowPost post, String comment}) {
    commentsRef.document(post.id).collection('liveShowPostComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  static void subscribeUser({String currentUserId, String userId}) {
    // Add user to current user's subscribeing collection
    subscribingRef
        .document(currentUserId)
        .collection('userSubscribing')
        .document(userId)
        .setData({});
    // Add current user to user's subscribeers collection
    subscribersRef
        .document(userId)
        .collection('userSubscribers')
        .document(currentUserId)
        .setData({});
  }

  static void unsubscribeUser({String currentUserId, String userId}) {
    // Remove user from current user's subscribeing collection
    subscribingRef
        .document(currentUserId)
        .collection('userSubscribing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove current user from user's subscribeers collection
    subscribersRef
        .document(userId)
        .collection('userSubscribers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isSubscribingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot subscribingDoc = await subscribersRef
        .document(userId)
        .collection('userSubscribers')
        .document(currentUserId)
        .get();
    return subscribingDoc.exists;
  }

  static Future<int> numSubscribing(String userId) async {
    QuerySnapshot subscribeingSnapshot = await subscribingRef
        .document(userId)
        .collection('userSubscribing')
        .getDocuments();
    return subscribeingSnapshot.documents.length;
  }

  static Future<int> numSubscribers(String userId) async {
    QuerySnapshot subscribeersSnapshot = await subscribersRef
        .document(userId)
        .collection('userSubscribers')
        .getDocuments();
    return subscribeersSnapshot.documents.length;
  }

  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'fullName': user.fullName,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'stagesUser': user.stagesUser,
      'birthDate': user.birthDate,
      'nickname': user.nickname,
      'recordLabel': user.recordLabel,
    });
  }

  static Future<QuerySnapshot> searchUsers(String fullName) {
    Future<QuerySnapshot> users = usersRef
        .where('fullName', isGreaterThanOrEqualTo: fullName)
        .getDocuments();
    return users;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static void createImagePost(Post post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'video': post.video,
      'starCount': post.starCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void createVideoPost(Post post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'video': post.video,
      'starCount': post.starCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void createLiveShowVideoPost(LiveShowPost post) {
    liveShowPostsRef
        .document(post.authorId)
        .collection('userLiveShowPosts')
        .add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'video': post.video,
      'cost': post.cost,
      'dateTime': post.dateTime,
      'starCount': post.starCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void createLiveShowPost(LiveShowPost post, youtubeUrl) {
    liveShowPostsRef
        .document(post.authorId)
        .collection('userLiveShowPosts')
        .add({
      'showId': youtubeUrl,
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'cost': post.cost,
      'video': post.video,
      'starCount': post.starCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
      'dateTime': post.dateTime,
    });
  }

  static void createNewProduct(ProductModel product) {
    productsRef.document(product.shopId).collection('userShopProducts').add({
      'imageUrl': product.imageUrl,
      'title': product.title,
      'description': product.description,
      'cost': product.cost,
      'sale': product.sale,
      'authorId': product.shopId,
      'timestamp': product.timestamp,
    });
  }

  static void createLesson(Lesson lesson) {
    lessonsRef.document(lesson.authorId).collection('userLessons').add({
      "id": lesson.youtubeUrl,
      'youtubeUrl': lesson.youtubeUrl,
      'description': lesson.description,
      'imageUrl': lesson.imageUrl,
      'lessonTitle': lesson.lessonTitle,
      'isLive': lesson.isLive,
      'starCount': lesson.starCount,
      'authorId': lesson.authorId,
      'timestamp': lesson.timestamp,
      'dateTime': lesson.dateTime,
    });
  }

  static void createLiveShow(LiveShow liveShow) {
    liveShowsRef.document(liveShow.authorId).collection('userLiveShows').add({
      'youtubeUrl': liveShow.youtubeUrl,
      'description': liveShow.description,
      'liveShowTitle': liveShow.liveShowTitle,
      'starCount': liveShow.starCount,
      'isLive': liveShow.isLive,
      'cost': liveShow.cost,
      'authorId': liveShow.authorId,
      'timestamp': liveShow.timestamp,
      'dateTime': liveShow.dateTime,
    });
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .document(userId)
        .collection('usersActivities')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Activity> activity = userActivitiesSnapshot.documents
        .map((doc) => Activity.fromDoc(doc))
        .toList();
    return activity;
  }

  static void addActivityItem(
      {String currentUserId, Post post, String comment, Lesson lesson}) {
    if (post != null) {
      if (currentUserId != post.authorId) {
        activitiesRef
            .document(post.authorId)
            .collection('usersActivities')
            .add({
          'fromUserId': currentUserId,
          'postId': post.id,
          'postImageUrl': post.imageUrl,
          'comment': comment,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });
      }
    }

    if (lesson != null) {
      if (currentUserId != lesson.authorId) {
        activitiesRef
            .document(lesson.authorId)
            .collection('usersActivities')
            .add({
          'fromUserId': currentUserId,
          'lessonId': lesson.id,
          'postImageUrl': "assets/images/stage_icon.png",
          'youtubeUrl': lesson.youtubeUrl,
          'comment': comment,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });
      }
    }
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .document(postId)
        .get();
    return Post.fromDoc(postDocSnapshot);
  }

  static Future<LiveShowPost> getUserLiveShowPost(
      String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await liveShowsRef
        .document(userId)
        .collection('userLiveShowPosts')
        .document(postId)
        .get();
    return LiveShowPost.fromDoc(postDocSnapshot);
  }

  static Future<Lesson> getUserLesson(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await lessonsRef
        .document(userId)
        .collection('userLessons')
        .document(postId)
        .get();
    return Lesson.fromDoc(postDocSnapshot);
  }
}

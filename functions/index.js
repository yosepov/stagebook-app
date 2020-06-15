
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onsubscribeUser = functions.firestore
    .document('/subscribers/{userId}/userSubscribers/{subscriberId}')
    .onCreate(async (snapshot, context) => {
        console.log(snapshot.data());
        const userId = context.params.userId;
        const subscriberId = context.params.subscriberId;
        const subscribedUserPostsRef = admin
            .firestore()
            .collection('posts')
            .doc(userId)
            .collection('userPosts');

        const userFeedRef = admin
            .firestore()
            .collection('feeds')
            .doc(subscriberId)
            .collection('userFeed');
        const subscribedUserPostsSnapshot = await subscribedUserPostsRef.get();
        subscribedUserPostsSnapshot.forEach(doc => {
            if (doc.exists) {
                userFeedRef.doc(doc.id).set(doc.data());
            }
        });


    });

exports.onUnsubscribeUser = functions.firestore
    .document('/subscribers/{userId}/userSubscribers/{subscriberId}')
    .onDelete(async (snapshot, context) => {
        const userId = context.params.userId;
        const subscriberId = context.params.subscriberId;
        const userFeedRef = admin
            .firestore()
            .collection('feeds')
            .doc(subscriberId)
            .collection('userFeed')
            .where('authorId', '==', userId);
        const userPostsSnapshot = await userFeedRef.get();
        userPostsSnapshot.forEach(doc => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });
    });

exports.onUploadPost = functions.firestore
    .document('/posts/{userId}/userPosts/{postId}')
    .onCreate(async (snapshot, context) => {
        console.log(snapshot.data());
        const userId = context.params.userId;
        const postId = context.params.postId;
        const userSubscribersRef = admin
            .firestore()
            .collection('subscribers')
            .doc(userId)
            .collection('userSubscribers');
        const userSubscribersSnapshot = await userSubscribersRef.get();
        userSubscribersSnapshot.forEach(doc => {
            admin
                .firestore()
                .collection('feeds')
                .doc(doc.id)
                .collection('userFeed')
                .doc(postId)
                .set(snapshot.data());
        });
    });



// exports.onUploadLiveShowPost = functions.firestore
//     .document('/liveShowPosts/{userId}/userLiveShowPosts/{postId}')
//     .onCreate(async (snapshot, context) => {
//         console.log(snapshot.data());
//         const userId = context.params.userId;
//         const postId = context.params.postId;
//         const userSubscribersRef = admin
//             .firestore()
//             .collection('subscribers')
//             .doc(userId)
//             .collection('userSubscribers');
//         const userSubscribersSnapshot = await userSubscribersRef.get();
//         userSubscribersSnapshot.forEach(doc => {
//             admin
//                 .firestore()
//                 .collection('feeds')
//                 .doc(doc.id)
//                 .collection('userLiveShowFeed')
//                 .doc(postId)
//                 .set(snapshot.data());
//         });
//     });

exports.onUpdatePost = functions.firestore
    .document('/posts/{userId}/userPosts/{postId}')
    .onUpdate(async (snapshot, context) => {
        const userId = context.params.userId;
        const postId = context.params.postId;
        const newPostData = snapshot.after.data();
        console.log(newPostData);
        const userSubscribersRef = admin
            .firestore()
            .collection('subscribers')
            .doc(userId)
            .collection('userSubscribers');
        const userSubscribersSnapshot = await userSubscribersRef.get();
        userSubscribersSnapshot.forEach(async userDoc => {
            const postRef = admin
                .firestore()
                .collection('feeds')
                .doc(userDoc.id)
                .collection('userFeed');
            const postDoc = await postRef.doc(postId).get();
            if (postDoc.exists) {
                postDoc.ref.update(newPostData);
            }
        });
    });


// exports.onUpdateLiveShowPost = functions.firestore
//     .document('/liveShowPosts/{userId}/userPosts/{postId}')
//     .onUpdate(async (snapshot, context) => {
//         const userId = context.params.userId;
//         const postId = context.params.postId;
//         const newPostData = snapshot.after.data();
//         console.log(newPostData);
//         const userSubscribersRef = admin
//             .firestore()
//             .collection('subscribers')
//             .doc(userId)
//             .collection('userSubscribers');
//         const userSubscribersSnapshot = await userSubscribersRef.get();
//         userSubscribersSnapshot.forEach(async userDoc => {
//             const postRef = admin
//                 .firestore()
//                 .collection('feeds')
//                 .doc(userDoc.id)
//                 .collection('userLiveShowFeed');
//             const postDoc = await postRef.doc(postId).get();
//             if (postDoc.exists) {
//                 postDoc.ref.update(newPostData);
//             }
//         });
//     });
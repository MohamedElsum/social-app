import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:social_app/models/post.dart';
import 'package:social_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, File file, String uid,
      String username, String profImage) async {
    String res = 'some error occurred';
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(childName: 'posts', isPost: true, file: file);
      String postId = Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        postId: postId,
        likes: [],
      );
      await firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String username, String photoUrl) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': photoUrl,
          'username': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is Empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}

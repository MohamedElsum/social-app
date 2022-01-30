import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post(
      {required this.uid,
        required this.description,
        required this.datePublished,
        required this.username,
        required this.postUrl,
        required this.postId,
        required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
    'username': username,
    'description':description ,
    'datePublished': datePublished,
    'postId' : postId,
    'postUrl': postUrl,
    'uid': uid,
    'profImage': profImage,
    'likes' : likes,
  };
  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = (snap.data() as Map<String,dynamic>);
    return Post(
      username: snapshot['username'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}

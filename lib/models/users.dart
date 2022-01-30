import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String bio;
  final String photoUrl;
  final List following;
  final List followers;

  User(
      {required this.uid,
      required this.email,
      required this.bio,
      required this.username,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'bio': bio,
        'photoUrl': photoUrl,
        'uid': uid,
        'following': following,
        'followers': followers,
      };
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = (snap.data() as Map<String,dynamic>);
    return User(
      username: snapshot['username'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      following: snapshot['following'],
      followers: snapshot['followers'],
    );
  }
}

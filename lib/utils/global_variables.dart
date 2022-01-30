import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/add_post_screen.dart';
import 'package:social_app/screens/feed_screen.dart';
import 'package:social_app/screens/profile_screen.dart';
import 'package:social_app/screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('Notifications')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

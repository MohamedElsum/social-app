import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/screens/comments_screen.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/models/users.dart';
import 'package:social_app/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    setState(() {
      commentLength = snap.docs.length;
    });
    setState(() {
      isLoading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text('Settings'),
                            children: [
                              SimpleDialogOption(
                                onPressed: () async {
                                  await FirestoreMethods()
                                      .deletePost(widget.snap['postId']);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete',style: TextStyle(
                                  color: Colors.red,fontWeight: FontWeight.bold
                                ),),
                              ),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: LikeAnimation(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 130.0,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          )));
                },
                icon: Icon(
                  Icons.comment,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  )),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Text(
                '${widget.snap['likes'].length} Likes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    TextSpan(
                      text: '   ${widget.snap['description']}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                        snap: widget.snap,
                      )));
            },
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                child: Text(
                  'View all $commentLength comments',
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
              child: Text(
                DateFormat.yMMMd()
                    .format(widget.snap['datePublished'].toDate()),
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/utils/utils.dart';
import 'dart:io';
import 'package:social_app/models/users.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? file;
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          descriptionController.text, file as File, uid, username, profImage);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar('Posted', context);
        clearImage();
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(10.0),
              child: Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? camImage = await pickImage(ImageSource.camera);
                setState(() {
                  file = camImage;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10.0),
              child: Text('Choose a photo from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? galleryImage = await pickImage(ImageSource.gallery);
                setState(() {
                  file = galleryImage;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10.0),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return file == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  selectImage(context);
                },
                child: Image(
                  width: 200,
                  height: 150,
                  image: NetworkImage(
                    'https://www.freeiconspng.com/uploads/upload-icon-3.png',
                  ),
                ),
              ),
            ],
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoUrl),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
            body: Column(
              children: [
                isLoading ? LinearProgressIndicator() : Container(),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Write a Caption ...',
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      width: 65.0,
                      height: 65.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(file as File),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

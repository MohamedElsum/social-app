import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      {required String childName, required bool isPost, required File? file}) async {
     var ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    if(isPost){
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    await ref.putFile(file as File);
    final url = await ref.getDownloadURL();
    return url;
  }
}

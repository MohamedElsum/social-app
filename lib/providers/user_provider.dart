import 'package:flutter/cupertino.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/models/users.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}

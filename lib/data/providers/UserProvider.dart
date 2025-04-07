import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User user;

  UserProvider({this.user});

  updateUser(updatedUser) {
    user = updatedUser;
    notifyListeners();
  }
}

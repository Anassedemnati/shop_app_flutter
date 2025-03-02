
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? userId;
  String? email;
  String? userName;
  String? token;
  DateTime? expiryDate;
  bool? isAdmin = false;

  User({this.userId, this.email, this.token, this.expiryDate, this.userName, this.isAdmin});

  bool get isAuth {
    return token != null;
  }

}

class UserProvider with ChangeNotifier { 
  User? _user = 
  User(userId: "d07e2c6b-0da5-4d22-85f3-75edbaada89f",
  email: "Mark@gmail.com",
  expiryDate: DateTime.now().add(Duration(days: 1)),
  token: 'some token',
  userName: 'Mark Smith',
  isAdmin: true
  );

  

  User? get user {
    return _user;
  }

  bool get isAuthenticated => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}


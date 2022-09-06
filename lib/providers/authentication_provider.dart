import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider extends ChangeNotifier {
  User? _firebaseUser;
  String _userId = "", _mobileNumber = "";

  User? get firebaseUser => _firebaseUser;

  void setFirebaseUser(User? user, {bool isNotify = true}) {
    _firebaseUser = user;
    if(isNotify) {
      notifyListeners();
    }
  }

  String get userId => _userId;

  void setUserId(String userId, {bool isNotify = true}) {
    _userId = userId;
    if(isNotify) {
      notifyListeners();
    }
  }

  String get mobileNumber => _mobileNumber;

  void setMobileNumber(String mobile, {bool isNotify = true}) {
    _mobileNumber = mobile;
    if(isNotify) {
      notifyListeners();
    }
  }

  void clearData({bool isNotify = true}) {
    setFirebaseUser(null);
    setUserId("");
    setMobileNumber("");
    if(isNotify) {
      notifyListeners();
    }
  }
}
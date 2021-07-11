import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/screens/auth_screen.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  Future<Void> authenticate(
      String email, String password, AuthMode loginOrSingup) async {
    String url;
    if (loginOrSingup == AuthMode.Login) {
      url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC_NqlCDMwdPZptktuxAvMUcL8wUY_vtCo';
    } else {
      url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC_NqlCDMwdPZptktuxAvMUcL8wUY_vtCo';
    }
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = await json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
      final perfs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      perfs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin()async{
    final perefs= await SharedPreferences.getInstance();
    if(!perefs.containsKey('userData')){
      return false;
    }
    final extactedUserData =json.decode(perefs.getString('userData')) as Map<String ,Object>;
    final expiryDate = DateTime.parse(extactedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _expiryDate = expiryDate;
    _userId = extactedUserData['userId'];
    _token = extactedUserData['token'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() {
    _userId = null;

    _expiryDate = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() async{
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    final pref =await SharedPreferences.getInstance();
    //pref.remove('userData');
    pref.clear();
  }

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
}

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';


class LoginInfo {
  String type;
  String? guestId;
  String? userId;
  String? userName;
  String? email;
  String? password;
  String isSynced;
  int notesLength;

  LoginInfo({
    required this.type,
    this.guestId,
    this.userId,
    this.userName,
    this.email,
    this.password,
    required this.isSynced,
    required this.notesLength,

});

  LoginInfo.user({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
    required this.isSynced,
    required this.notesLength,

}) : type = 'user', guestId = null;



  LoginInfo.guest({
    required this.guestId,
    required this.isSynced,
    required this.notesLength,

  }) : type = 'guest', userId = null, userName = null, email = null, password = null;

}

class LoginInfoRepository {
  static const String boxName = "LoginInfoBox";

  static Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    } else {
      return await Hive.openBox<dynamic>(boxName);
    }
  }

  static Future<bool> checkLoginInfoBoxExists() async {
    bool exists = await Hive.boxExists(boxName);
    return exists;
  }


  static Future<LoginInfo> getLoginInfo() async {
    Box<dynamic> box = await _openBox();
    for(int i in box.keys.toList()) {
      print('fetching = key : $i --> value : ${box.get(i)}');
    }
    if((box.get('type') as String) == 'user') {
      return LoginInfo.user(userId: box.get('userId'), userName: box.get('userName'), email: box.get('email'), password: box.get('password'), isSynced: box.get('isSynced'), notesLength: box.get('notesLength'));
    } else {
      return LoginInfo.guest(guestId: box.get('guestId'), isSynced: box.get('isSynced'), notesLength: box.get('notesLength'));
    }

  }

  static Future<void> createLoginInfo(LoginInfo loginInfo) async {
    Box<dynamic> box = await _openBox();
    box.clear();
    box.putAll({'type': loginInfo.type, 'guestId': loginInfo.guestId, 'userId': loginInfo.userId, 'userName': loginInfo.userName, 'email': loginInfo.email, 'password': loginInfo.password, 'isSynced': loginInfo.isSynced, 'notesLength': loginInfo.notesLength});

  }


}


class LoginInfoProvider with ChangeNotifier {
  late LoginInfo _loginInfo;
  LoginInfo get loginInfo {
    return _loginInfo;
  }



  void getLoginInfo() async {
    LoginInfo loginInfo = await LoginInfoRepository.getLoginInfo();
    _loginInfo = loginInfo;

    notifyListeners();

  }



  void createLoginInfo(LoginInfo loginInfo) async {
    await LoginInfoRepository.createLoginInfo(loginInfo);

  }


}
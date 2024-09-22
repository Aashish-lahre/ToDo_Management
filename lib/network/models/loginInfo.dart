import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';


class LoginInfo {
  String type;
  String? userId;
  String? userName;
  String? email;
  String? password;
  bool isSynced;


  LoginInfo({
    required this.type,

    this.userId,
    this.userName,
    this.email,
    this.password,
    required this.isSynced,


});

  LoginInfo.user({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
    required this.isSynced,


}) : type = 'user';



  LoginInfo.guest({
    required this.isSynced,

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
    print('entered get login info box');
    Box<dynamic> box = await _openBox();
print('after open box');
    // for(int i in box.keys.toList()) {
    //   print('fetching = key : $i --> value : ${box.get(i)}');
    // }
    if((box.get('type') as String) == 'user') {
      return LoginInfo.user(userId: box.get('userId'), userName: box.get('userName'), email: box.get('email'), password: box.get('password'), isSynced: box.get('isSynced'));
    } else {
      return LoginInfo.guest(isSynced: box.get('isSynced'));
    }

  }

  static Future<LoginInfo> createLoginInfo(LoginInfo loginInfo) async {
    Box<dynamic> box = await _openBox();
    box.clear();
    box.putAll({'type': loginInfo.type, 'userId': loginInfo.userId, 'userName': loginInfo.userName, 'email': loginInfo.email, 'password': loginInfo.password, 'isSynced': loginInfo.isSynced,});
    return getLoginInfo();
  }


}


class LoginInfoProvider with ChangeNotifier {

  LoginInfoProvider() {
    print('called');
    _initialize();
  }

   late LoginInfo _loginInfo;
  LoginInfo get loginInfo {
    return _loginInfo;
  }

  Future<void> _initialize() async {
    if(await loginInfoBoxExists()) {
      print('login box exists');
      return getLoginInfo();
    }
  }

  Future<bool> loginInfoBoxExists() async {
    bool exists = await LoginInfoRepository.checkLoginInfoBoxExists();
    return exists;
  }



  void getLoginInfo() async {
    print('about to fetch : getLoginInfo');
    LoginInfo loginInfo = await LoginInfoRepository.getLoginInfo();
    _loginInfo = loginInfo;
    print("login box initialized : $_loginInfo");

    notifyListeners();

  }



  void createLoginInfo(LoginInfo createloginInfo) async {
    LoginInfo newLoginInfo = await LoginInfoRepository.createLoginInfo(createloginInfo);
    _loginInfo = newLoginInfo;
    print('login info initialized');
    notifyListeners();

  }


}
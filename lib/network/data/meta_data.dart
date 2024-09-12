import 'package:hive/hive.dart';

class MetaDataRepository {
  final String boxName = "MetaDataBox";

  Future<Box<dynamic>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    } else {
      return await Hive.openBox<dynamic>(boxName);
    }
  }


Future<Box<dynamic>> getLoginInfo() async {
  Box<dynamic> box = await openBox();
  for(int i in box.keys.toList()) {
    print('fetching = key : $i --> value : ${box.get(i)}');

  }

  return box;
}
}
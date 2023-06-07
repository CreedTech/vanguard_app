import 'package:hive/hive.dart';
import 'local_db.dart';

class Boxes {
  static Box savePosts() {
    return Hive.box('saveposts');
  }

  static Box saveTheme() {
    return Hive.box('themedata');
  }

  static Box saveNotification() {
    return Hive.box('savenotification');
  }

  static Box saveNotificationOnOff() {
    return Hive.box('saveNotificationOnOff');
  }
}
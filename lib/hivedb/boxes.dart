import 'package:hive/hive.dart';
import 'local_db.dart';

class Boxes {
  static late Box<SaveArticle> _savePostsBox;
  static late Box<DarkTheme> _saveThemeBox;
  static late Box<SaveNotification> _saveNotificationBox;
  static late Box<SaveNotificationOnOff> _saveNotificationOnOffBox;

  static Box<SaveArticle> get savePosts {
    if (_savePostsBox == null || !_savePostsBox.isOpen) {
      _savePostsBox = Hive.box<SaveArticle>('saveposts');
    }
    return _savePostsBox;
  }

  static Box<DarkTheme> get saveTheme {
    if (_saveThemeBox == null || !_saveThemeBox.isOpen) {
      _saveThemeBox = Hive.box<DarkTheme>('themedata');
    }
    return _saveThemeBox;
  }

  static Box<SaveNotification> get saveNotification {
    if (_saveNotificationBox == null || !_saveNotificationBox.isOpen) {
      _saveNotificationBox = Hive.box<SaveNotification>('savenotification');
    }
    return _saveNotificationBox;
  }

  static Box<SaveNotificationOnOff> get saveNotificationOnOff {
    if (_saveNotificationOnOffBox == null ||
        !_saveNotificationOnOffBox.isOpen) {
      _saveNotificationOnOffBox =
          Hive.box<SaveNotificationOnOff>('saveNotificationOnOff');
    }
    return _saveNotificationOnOffBox;
  }
}

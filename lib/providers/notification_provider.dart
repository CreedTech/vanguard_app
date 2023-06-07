import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import '../hivedb/boxes.dart';
import '../hivedb/local_db.dart';

class NotificationProvider extends ChangeNotifier {
  late bool _checkNotfication;
  Box? codeBox;

  bool get checkNotfication => _checkNotfication;

  NotificationProvider() {
    _checkNotfication = false;
    loadNotificationData();
  }
  toggleNotfication() {
    _checkNotfication = !_checkNotfication;
    saveNotificationData();
    notifyListeners();
  }

  saveNotificationData() {
    final box = Hive.box('saveNotificationOnOff');
    final isNotficationOn = SaveNotificationOnOff()
      ..isNotficationOn = _checkNotfication;
    box.put("isNotficationOn", isNotficationOn);
  }

  loadNotificationData() {
    final data = Hive.box('saveNotificationOnOff').get("isNotficationOn");
    if (data != null) {
      _checkNotfication = data.isNotficationOn;
    }
  }
}

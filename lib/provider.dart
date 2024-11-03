import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String appName = "KMS";
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners(); // 通知监听器
  }
}

import 'dart:async';

import 'package:sidebarx/sidebarx.dart';

class MySidebarXController extends SidebarXController {
  MySidebarXController({
    required int selectedIndex,
    bool? extended,
  }) : _selectedIndex = selectedIndex, super(selectedIndex: 0) {
    _setExtedned(extended ?? false);
  }

  int _selectedIndex;
  var _extended = false;

  final _extendedController = StreamController<bool>.broadcast();
  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  int get selectedIndex => _selectedIndex;
  void selectIndex(int val) {
    _selectedIndex = val;
    notifyListeners();
  }

  bool get extended => _extended;
  void setExtended(bool extended) {
    _extended = extended;
    _extendedController.add(extended);
    notifyListeners();
  }

  void toggleExtended() {
    _extended = !_extended;
    _extendedController.add(_extended);
    notifyListeners();
  }

  void _setExtedned(bool val) {
    _extended = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _extendedController.close();
    super.dispose();
  }
}

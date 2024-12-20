import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kms/models/page.dart';
import 'package:kms/page_controller.dart';
import 'package:kms/pages/api_key/index.dart';
import 'package:kms/pages/editor/index.dart';
import 'package:kms/pages/home.dart';
import 'package:kms/pages/key_manager/asymmetric.dart';
import 'package:kms/pages/key_manager/symmetric.dart';
import 'package:kms/pages/setting/index.dart';
import 'package:kms/pages/test.dart';
import 'package:kms/preferences.dart';
import 'package:kms/widget/side_bar/controller.dart';
import 'package:kms/widget/side_bar/index.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  await GetStorage.init();
  Get.put(GetxPageController());
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          ThemeNotifier(lightTheme, context, ThemeMode.light, tableStyleLight),
      child: const MainApp(),
    ),
  );
}

const List<PageInfo> pages = [
  PageInfo(icon: Icons.home, label: "主页", page: Home()),
  PageInfo(icon: Icons.vpn_key, label: "对称密钥", page: Symmetric()),
  PageInfo(icon: Icons.blur_on, label: "非对称密钥", page: Asymmetric()),
  PageInfo(icon: Icons.api, label: "AaiKey", page: ApiKeyPage()),
  PageInfo(icon: Icons.settings, label: " 测试", page: TestPage()),
  PageInfo(icon: Icons.book, label: "编辑器", page: EditorPage()),
];

const List<PageInfo> footPages = [
  PageInfo(icon: Icons.settings, label: "设置", page: SettingPage())
];

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const selectedIcon = Icon(TDIcons.home);
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<MainApp> with TickerProviderStateMixin {
  var controller = SidebarController(selectedIndex: 0, extended: true);
  List<SideBarItem> _items = [];
  List<SideBarItem> _footItems = [];
  @override
  void initState() {
    super.initState();
    _items = pages
        .map((e) => SideBarItem(
              icon: Icon(
                e.icon,
                size: 20,
              ),
              title: Text(e.label, overflow: TextOverflow.ellipsis),
            ))
        .toList();
    _footItems = footPages
        .map((e) => SideBarItem(
              icon: Icon(
                e.icon,
                size: 20,
              ),
              title: Text(e.label, overflow: TextOverflow.ellipsis),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
            return GetMaterialApp(
              theme: themeNotifier.currentTheme,
              darkTheme: darkTheme,
              themeMode: themeNotifier.themeMode,
              home: Scaffold(
                body: Row(
                  children: [
                    SideBar(
                      items: _items,
                      footItems: _footItems,
                      controller: controller,
                      itemHeight: 40,
                      extendedWidth: 200,
                    ),
                    Expanded(
                        child: IndexedStack(
                      index: controller.selectedIndex,
                      children: [
                        ...pages.map((e) => e.page).toList(),
                        ...footPages.map((e) => e.page).toList()
                      ],
                    ))
                  ],
                ),
              ),
            );
          });
        });
  }
}

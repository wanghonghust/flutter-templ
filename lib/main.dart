import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kms/models/page.dart';
import 'package:kms/pages/api_key/index.dart';
import 'package:kms/pages/editor/index.dart';
import 'package:kms/pages/home.dart';
import 'package:kms/pages/key_manager/asymmetric.dart';
import 'package:kms/pages/key_manager/symmetric.dart';
import 'package:kms/pages/test.dart';
import 'package:kms/preferences.dart';
import 'package:kms/widget/menu_bar.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeNotifier(lightTheme, false, ThemeMode.system, tableStyleLight),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const selectedIcon = Icon(TDIcons.home);
  @override
  State<StatefulWidget> createState() {
    return KMSState();
  }
}

class KMSState extends State<MainApp> {
  List<PageInfo> pages = [
    const PageInfo(icon: Icons.home, label: "主页", page: Home()),
    const PageInfo(icon: Icons.vpn_key, label: "对称密钥", page: Symmetric()),
    const PageInfo(icon: Icons.vpn_key, label: "非对称密钥", page: Asymmetric()),
    const PageInfo(icon: Icons.api, label: "AaiKey", page: ApiKeyPage()),
    const PageInfo(icon: Icons.settings, label: " 测试", page: TestPage()), 
    const PageInfo(icon: Icons.book, label: "编辑器", page: EditorPage()),
  ];
  var controller = SidebarXController(selectedIndex: 0, extended: true);
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
            return MaterialApp(
              theme: themeNotifier.currentTheme,
              darkTheme: darkTheme,
              themeMode: themeNotifier.themeMode,
              home: Scaffold(
                key: key,
                appBar: isSmallScreen
                    ? AppBar(
                        title: Text(_getTitleByIndex(controller.selectedIndex)),
                        leading: IconButton(
                          onPressed: () {
                            if (!Platform.isAndroid && !Platform.isIOS) {
                              controller.setExtended(true);
                            }
                            key.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                          splashRadius: 24,
                        ),
                        actions: [
                          Builder(builder: (BuildContext context) {
                            return IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(createRoute());
                                },
                                icon: const Icon(Icons.settings));
                          }),
                        ],
                      )
                    : null,
                drawer: ExampleSidebarX(
                  controller: controller,
                  pages: pages,
                ),
                body: Row(
                  children: [
                    if (!isSmallScreen)
                      ExampleSidebarX(controller: controller, pages: pages),
                    Expanded(
                      child: _Screen(
                        controller: controller,
                        pages: pages,
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: isSmallScreen
                    ? _textTypeTabBar5tabs(context, controller)
                    : null,
              ),
            );
          });
        });
  }

  Widget _textTypeTabBar5tabs(
      BuildContext context, SidebarXController controller) {
    final List<BottomNavigationBarItem> tabs = [];
    for (int i = 0; i < pages.length; i++) {
      tabs.add(BottomNavigationBarItem(
        icon: Icon(pages[i].icon),
        label: pages[i].label,
      ));
    }
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.selectedIndex,
        onTap: (int index) {
          setState(() {
            controller.selectIndex(index);
          });
        },
        items: tabs);
  }

  String _getTitleByIndex(int index) {
    if (index >= pages.length) {
      return "";
    }
    return pages[index].label;
  }
}

class _Screen extends StatelessWidget {
  const _Screen({
    super.key,
    required this.controller,
    required this.pages,
  });

  final SidebarXController controller;
  final List<PageInfo> pages;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          color: Colors.transparent,
          child: pages[controller.selectedIndex].page,
        );
      },
    );
  }
}

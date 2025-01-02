import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kms/models/page.dart';
import 'package:kms/page_controller.dart';
import 'package:kms/pages/api_key/index.dart';
import 'package:kms/pages/editor/index.dart';
import 'package:kms/pages/home.dart';
import 'package:kms/pages/key_manager/asymmetric.dart';
import 'package:kms/pages/key_manager/symmetric.dart';
import 'package:kms/pages/login/index.dart';
import 'package:kms/pages/screen.dart';
import 'package:kms/pages/setting/index.dart';
import 'package:kms/pages/test.dart';
import 'package:kms/preferences.dart';
import 'package:kms/widget/menu_bar.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const selectedIcon = Icon(TDIcons.home);
  @override
  State<StatefulWidget> createState() {
    return KMSState();
  }
}

class KMSState extends State<MainApp> with TickerProviderStateMixin {
  var controller = SidebarXController(selectedIndex: 0, extended: true);
  var pageController = Get.find<GetxPageController>();
  final key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    pageController.page.value = pages[controller.selectedIndex].page;
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
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
                key: key,
                appBar: !isDesktop
                    ? AppBar(
                        title: Text(_getTitleByIndex(controller.selectedIndex)),
                        actions: [
                          Builder(builder: (BuildContext context) {
                            return IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(createRoute(const SettingPage()));
                                },
                                icon: const Icon(Icons.settings));
                          }),
                          Builder(builder: (BuildContext context) {
                            return IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(createRoute(const LoginPage()));
                                },
                                icon: const Icon(Icons.person));
                          }),
                        ],
                      )
                    : null,
                drawer: isDesktop
                    ? ExampleSidebarX(
                        controller: controller,
                        pages: pages,
                      )
                    : null,
                body: LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    children: [
                      if (isDesktop)
                        ExampleSidebarX(controller: controller, pages: pages),
                      Expanded(
                        child: IndexedStack(
                          index: controller.selectedIndex,
                          children: pages
                              .map((e) => e.page)
                              .toList()
                        ),
                      ),
                    ],
                  );
                }),
                bottomNavigationBar: !isDesktop ? _buildBottomBar() : null,
              ),
            );
          });
        });
  }

  Widget _buildBottomBar() {
    List<MyBottomNavigationBarItem> items = [];
    for (int i = 0; i < pages.length; i++) {
      items.add(MyBottomNavigationBarItem(
        icon: Icon(pages[i].icon),
        title: Text(pages[i].label),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
        textAlign: TextAlign.center,
      ));
    }
    return CustomAnimatedBottomBar(
      containerHeight: 56,
      selectedIndex: controller.selectedIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeInOutQuart,
      onItemSelected: (index) => {
        pageController.page.value = pages[index].page,
        controller.selectIndex(index)
      },
      items: items,
    );
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
    this.page,
  });

  final Widget? page;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.transparent,
          child: page,
        );
      },
    );
  }
}
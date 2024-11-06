import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kms/models/page.dart';
import 'package:kms/page_controller.dart';
import 'package:kms/pages/setting/index.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    super.key,
    required SidebarXController controller,
    required this.pages,
  }) : _controller = controller;

  final SidebarXController _controller;
  final List<PageInfo> pages;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final List<SidebarXItem> items = [];
    final pageController = Get.find<GetxPageController>();
    for (var it in pages) {
      items.add(SidebarXItem(
          icon: it.icon,
          label: it.label,
          onTap: () {
            pageController.page.value = it.page;
            print(pageController.page.value);
          }));
    }
    return SidebarX(
      controller: _controller,
      showToggleButton: !isSmallScreen,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSmallScreen
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(10),
        ),
        hoverColor: Theme.of(context).hoverColor,
        textStyle: Theme.of(context).appBarTheme.titleTextStyle,
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor
            ],
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorDark,
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: isSmallScreen
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).hoverColor,
        ),
      ),
      headerDivider: Divider(
          color: Theme.of(context).dividerColor.withOpacity(0.15), height: 1),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: extended ? 80 : 64,
          width: extended ? 80 : 64,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/avatar.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      items: items,
      footerBuilder: (context, extended) {
        return Container(
          margin: const EdgeInsets.all(4),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // 设置圆角半径
              ),
              padding: const EdgeInsets.only(left: 6, right: 6),
            ),
            child: Row(
              mainAxisAlignment: extended
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                const Icon(TDIcons.setting),
                if (extended)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: const Text("设置"),
                    ),
                  ),
              ],
            ),
            onPressed: () => {
              pageController.page.value = const SettingPage(),
              print(pageController.page.value)
            },
          ),
        );
      },
    );
  }
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease; // Curves.bounceInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

const white = Colors.white;

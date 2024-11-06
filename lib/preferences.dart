import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pluto_grid/pluto_grid.dart';

// final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: const Color.fromARGB(236, 130, 176, 255),
//     primaryColorDark: Colors.black,
//     primaryColorLight: Colors.white,
//     scaffoldBackgroundColor: Colors.white,
//     cardColor: const Color.fromARGB(255, 252, 252, 252),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//     ),
//     drawerTheme: const DrawerThemeData(backgroundColor: Colors.white));

// final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: const Color.fromARGB(255, 14, 134, 255),
//     primaryColorDark: Colors.white,
//     primaryColorLight: Colors.black,
//     scaffoldBackgroundColor: const Color.fromARGB(255, 28, 30, 35),
//     cardColor: Colors.black87,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.black87,
//     ),
//     drawerTheme: const DrawerThemeData(
//         backgroundColor: Color.fromARGB(255, 28, 30, 35)));

const PlutoGridStyleConfig tableStyleLight = PlutoGridStyleConfig(
  enableGridBorderShadow: false,
  enableColumnBorderVertical: true,
  enableColumnBorderHorizontal: true,
  enableCellBorderVertical: true,
  enableCellBorderHorizontal: true,
  enableRowColorAnimation: false,
  gridBackgroundColor: Colors.white,
  rowColor: Colors.white,
  activatedColor: Color(0xFFDCF5FF),
  checkedColor: Color(0x11757575),
  cellColorInEditState: Colors.white,
  cellColorInReadOnlyState: Color(0xFFDBDBDC),
  dragTargetColumnColor: Color(0xFFDCF5FF),
  iconColor: Colors.black26,
  disabledIconColor: Colors.black12,
  menuBackgroundColor: Colors.white,
  gridBorderColor: Color.fromRGBO(226, 226, 226, 0.357),
  borderColor: Color(0xFFDDE2EB),
  activatedBorderColor: Color.fromARGB(255, 11, 141, 255),
  inactivatedBorderColor: Color(0xFFC4C7CC),
  iconSize: 18,
  rowHeight: PlutoGridSettings.rowHeight,
  columnHeight: PlutoGridSettings.rowHeight,
  columnFilterHeight: PlutoGridSettings.rowHeight,
  defaultColumnTitlePadding: PlutoGridSettings.columnTitlePadding,
  defaultColumnFilterPadding: PlutoGridSettings.columnFilterPadding,
  defaultCellPadding: PlutoGridSettings.cellPadding,
  columnTextStyle: TextStyle(
    color: Colors.black,
    decoration: TextDecoration.none,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  cellTextStyle: TextStyle(
    color: Colors.black,
    fontSize: 14,
  ),
  columnContextIcon: Icons.dehaze,
  columnResizeIcon: Icons.code_sharp,
  rowGroupExpandedIcon: Icons.keyboard_arrow_down,
  rowGroupCollapsedIcon: IconData(
    0xe355,
    matchTextDirection: true,
    fontFamily: 'MaterialIcons',
  ),
  rowGroupEmptyIcon: Icons.noise_control_off,
  gridBorderRadius: BorderRadius.all(Radius.circular(5)),
  gridPopupBorderRadius: BorderRadius.all(Radius.circular(5)),
);

const PlutoGridStyleConfig tableStyleDark = PlutoGridStyleConfig(
  enableGridBorderShadow: false,
  enableColumnBorderVertical: true,
  enableColumnBorderHorizontal: true,
  enableCellBorderVertical: true,
  enableCellBorderHorizontal: true,
  enableRowColorAnimation: false,
  gridBackgroundColor: Color(0xFF111111),
  rowColor: Color(0xFF111111),
  activatedColor: Color(0xFF313131),
  checkedColor: Color(0x11202020),
  cellColorInEditState: Color(0xFF666666),
  cellColorInReadOnlyState: Color(0xFF222222),
  dragTargetColumnColor: Color(0xFF313131),
  iconColor: Colors.white38,
  disabledIconColor: Colors.white12,
  menuBackgroundColor: Color(0xFF414141),
  gridBorderColor: Color.fromRGBO(164, 164, 164, 0.357),
  borderColor: Color(0xFF222222),
  activatedBorderColor: Color(0xFFFFFFFF),
  inactivatedBorderColor: Color(0xFF666666),
  iconSize: 18,
  rowHeight: PlutoGridSettings.rowHeight,
  columnHeight: PlutoGridSettings.rowHeight,
  columnFilterHeight: PlutoGridSettings.rowHeight,
  defaultColumnTitlePadding: PlutoGridSettings.columnTitlePadding,
  defaultColumnFilterPadding: PlutoGridSettings.columnFilterPadding,
  defaultCellPadding: PlutoGridSettings.cellPadding,
  columnTextStyle: TextStyle(
    color: Colors.white,
    decoration: TextDecoration.none,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  cellTextStyle: TextStyle(
    color: Colors.white,
    fontSize: 14,
  ),
  columnContextIcon: Icons.dehaze,
  columnResizeIcon: Icons.code_sharp,
  rowGroupExpandedIcon: Icons.keyboard_arrow_down,
  rowGroupCollapsedIcon: IconData(
    0xe355,
    matchTextDirection: true,
    fontFamily: 'MaterialIcons',
  ),
  rowGroupEmptyIcon: Icons.noise_control_off,
  gridBorderRadius: BorderRadius.all(Radius.circular(5)),
  gridPopupBorderRadius: BorderRadius.all(Radius.circular(5)),
);

class ThemeNotifier with ChangeNotifier {
  final ThemeData _currentTheme;
  BuildContext context;
  ThemeMode _themeMode;
  PlutoGridStyleConfig _tableConfiguration;

  ThemeNotifier(this._currentTheme, this.context, this._themeMode,
      this._tableConfiguration);

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode =>
      Theme.of(context).colorScheme.brightness == Brightness.dark;
  PlutoGridStyleConfig get tableConfiguration => _tableConfiguration;
  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    print(Get.theme.brightness);
    _tableConfiguration = Get.isDarkMode ? tableStyleDark : tableStyleLight;
    notifyListeners();
  }
}

var lightTheme = FlexThemeData.light(
  scheme: FlexScheme.indigo,
  subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      appBarCenterTitle: false,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarMutedUnselectedIcon: true,
      navigationBarMutedUnselectedLabel: true,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorOpacity: 0.03,
      navigationBarIndicatorRadius: 8.0,
      navigationBarBackgroundSchemeColor: SchemeColor.transparent,
      navigationBarHeight: 60.0,
      adaptiveRemoveNavigationBarTint: FlexAdaptive.all(),
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      cardElevation: 0,
      searchBarElevation: 0.0,
      searchViewElevation: 0.0,
      searchBarRadius: 9.0,
      searchViewRadius: 9.0,
      bottomNavigationBarElevation: 10),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
);
var darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.indigo,
  // scaffoldBackground: const Color.fromARGB(255, 27, 27, 31),
  // appBarBackground: const Color.fromARGB(255, 39, 40, 48),

  subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      appBarCenterTitle: false,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarMutedUnselectedIcon: true,
      navigationBarMutedUnselectedLabel: true,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorOpacity: 0.03,
      navigationBarIndicatorRadius: 8.0,
      navigationBarBackgroundSchemeColor: SchemeColor.transparent,
      navigationBarHeight: 60.0,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      cardElevation: 0,
      searchBarElevation: 0.0,
      searchViewElevation: 0.0,
      searchBarRadius: 9.0,
      searchViewRadius: 9.0,
      bottomNavigationBarElevation: 10),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
);

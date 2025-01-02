import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabBarThemeData {
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? hoverBackgroundColor;
  final Color? textColor;
  final Color? activeTextColor;
  final Color? hoverTextColor;
  final Color? iconColor;
  final Color? closeIconColor;
  final Color? borderColor;

  // 根据当前的系统主题（亮色或暗色）返回默认主题
  static TabBarThemeData get light {
    return TabBarThemeData(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      activeBackgroundColor: const Color.fromARGB(255, 67, 85, 185),
      hoverBackgroundColor: const Color.fromARGB(255, 235, 237, 244),
      textColor: Colors.black,
      activeTextColor: Colors.white,
      hoverTextColor: Colors.black,
      iconColor: Colors.black,
      closeIconColor: const Color.fromARGB(108, 133, 133, 133),
      borderColor: const Color.fromARGB(167, 202, 202, 202),
    );
  }

  static TabBarThemeData get dark {
    return TabBarThemeData(
      backgroundColor: const Color.fromARGB(255, 14, 14, 14),
      activeBackgroundColor: const Color.fromARGB(255, 182, 191, 250),
      hoverBackgroundColor: const Color.fromARGB(255, 30, 31, 36),
      textColor: Colors.white,
      activeTextColor: Colors.black,
      hoverTextColor: Colors.white,
      iconColor: Colors.white,
      closeIconColor: const Color.fromARGB(138, 148, 148, 148),
      borderColor: const Color.fromARGB(61, 30, 30, 30),
    );
  }

  // 构造函数
  TabBarThemeData({
    this.backgroundColor = Colors.white,
    this.activeBackgroundColor = Colors.blue,
    this.hoverBackgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.activeTextColor = Colors.black,
    this.hoverTextColor = Colors.black,
    this.closeIconColor = Colors.red,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.black,
  });
}

// TabItem类
class TabItem {
  String id;
  String label;
  String? toolTip;
  IconData? icon;
  dynamic data;
  TabItem(
      {required this.id,
      required this.label,
      this.toolTip,
      this.data,
      this.icon});
  @override
  String toString() {
    return "TabItem{id: $id, label: $label,toolTip: $toolTip icon: $icon, data: $data}";
  }
}

// TabBar事件类型
typedef TabBarEvent = Function(TabItem item, int index, Offset offset);

// TabController类
class TabController extends ChangeNotifier {
  int selectedIndex;
  List<TabItem> items;

  TabController({required this.selectedIndex, required this.items}) {
    if (hasDuplicateIds()) {
      throw Exception("Id is not unique");
    }
  }

  // 检查是否有重复的ID
  bool hasDuplicateIds() {
    Set<String> ids = {};
    for (var item in items) {
      if (!ids.add(item.id)) {
        return true;
      }
    }
    return false;
  }

  // 检查ID是否唯一
  bool _isIdUnique(String id) {
    return !items.any((item) => item.id == id);
  }

  // 根据ID获取TabItem
  TabItem? getItemById(String id) {
    for (var item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  TabItem? getItemByIndex(int index) {
    if (index >= 0 && index < items.length) {
      return items[index];
    }
    return null;
  }

  // 根据ID选择TabItem
  void selectItemById(String id) {
    int index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      setSelectedIndex(index);
    }
  }

  // 设置选中的索引
  void setSelectedIndex(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  // 添加TabItem
  void addItem(TabItem item, {bool selectLast = false}) {
    if (!_isIdUnique(item.id)) {
      throw Exception("Id is not unique");
    }
    items.add(item);
    if (selectLast) {
      selectedIndex = items.length - 1;
    }
    notifyListeners();
  }

  // 移除指定索引的TabItem
  TabItem? removeItem(int index) {
    if (index >= 0 && index < items.length) {
      var item = items.removeAt(index);
      if (items.isEmpty) {
        selectedIndex = -1;
        notifyListeners();
        return item;
      }
      if (selectedIndex == index) {
        selectedIndex = items.length - 1;
        notifyListeners();
      } else if (selectedIndex > index) {
        selectedIndex -= 1;
        notifyListeners();
      }
      notifyListeners();
      return item;
    }
    notifyListeners();
    return null;
  }

  // 根据ID移除TabItem
  TabItem? removeItemById(String id) {
    int index = -1;
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      return removeItem(index);
    }

    return null;
  }

  String getTooltipText(int index) {
    if (index >= 0 && index < items.length) {
      return items[index].toolTip ?? "";
    }
    return "";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabController &&
        other.selectedIndex == selectedIndex &&
        listEquals(other.items, items);
  }
}

// 状态控制器类
class StateController extends ChangeNotifier {
  int _hoveredIndex = -1;
  int _pressedIndex = -1;
  int _closeIndex = -1;
  int _rightIndex = -1;
  int _tooltipIndex = -1;
  bool _hoveredIcon = false;

  int get hoveredIndex => _hoveredIndex;
  int get pressedIndex => _pressedIndex;
  int get closeIndex => _closeIndex;
  int get rightIndex => _rightIndex;
  int get tooltipIndex => _tooltipIndex;
  bool get hoveredIcon => _hoveredIcon;

  set hoveredIndex(int value) {
    _hoveredIndex = value;
    notifyListeners();
  }

  set pressedIndex(int value) {
    _pressedIndex = value;
    notifyListeners();
  }

  set closeIndex(int value) {
    _closeIndex = value;
    notifyListeners();
  }

  set rightIndex(int value) {
    _rightIndex = value;
    notifyListeners();
  }

  set tooltipIndex(int value) {
    _tooltipIndex = value;
    notifyListeners();
  }

  set hoveredIcon(bool value) {
    _hoveredIcon = value;
    notifyListeners();
  }

  @override
  String toString() {
    return 'hoveredIndex:$_hoveredIndex,pressedIndex:$_pressedIndex,hoveredIcon:$_hoveredIcon,closeIndex:$_closeIndex';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateController &&
        other._hoveredIndex == _hoveredIndex &&
        other._pressedIndex == _pressedIndex &&
        other._hoveredIcon == _hoveredIcon;
  }
}

// 自定义TabBar类
class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final double? tabWidth;
  final double? tabHeight;
  final TabBarEvent? onTabClick;
  final TabBarEvent? onTabClose;
  final TabBarEvent? onTabRightClick;
  final TabBarThemeData? theme;
  final bool? isCloseable;
  final BorderRadius? borderRadius;
  final GlobalKey key = GlobalKey();

  CustomTabBar({
    required this.tabController,
    this.onTabClick,
    this.onTabClose,
    this.onTabRightClick,
    this.tabWidth = 100,
    this.tabHeight = 32,
    this.theme,
    this.isCloseable = false,
    this.borderRadius = BorderRadius.zero,
  }) {}

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

// 自定义TabBar状态类
class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  final StateController _stateController = StateController();

  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_updateUi);
    _stateController.addListener(_updateUi);
  }

  void _updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.tabController.removeListener(_updateUi);
    _stateController.removeListener(_updateUi);
    _stateController.dispose();
    _scrollController.dispose();
    _timer?.cancel();
  }

  // 更新鼠标悬停索引
  void _updateHoveredIndex(Offset position) {
    bool find = false;
    for (int i = 0; i < widget.tabController.items.length; i++) {
      double startX = i * widget.tabWidth! - _scrollController.offset;
      Rect buttonRect =
          Rect.fromLTWH(startX, 0, widget.tabWidth!, widget.tabHeight!);
      if (buttonRect.contains(position)) {
        _stateController.hoveredIndex = i;
        find = true;
        break;
      }
    }
    if (!find) {
      _stateController.hoveredIndex = -1;
    }
  }

  // 更新鼠标悬停在关闭图标上的索引
  void _updateHoveredIconIndex(Offset position) {
    for (int i = 0; i < widget.tabController.items.length; i++) {
      double startX = (i + 1) * widget.tabWidth! -
          widget.tabHeight! -
          _scrollController.offset;
      Rect closeIconRect =
          Rect.fromLTWH(startX, 0, widget.tabHeight!, widget.tabHeight!);
      if (closeIconRect.contains(position)) {
        _stateController.hoveredIcon = true;
        return;
      }
    }
    _stateController.hoveredIcon = false;
  }

  // 处理鼠标按下事件
  void _onTapDown(TapDownDetails details) {
    final tabWidth = widget.tabWidth!;
    final tabHeight = widget.tabHeight!;
    final closeIconOffset =
        widget.isCloseable! ? tabWidth - tabHeight : tabWidth;

    for (int i = 0; i < widget.tabController.items.length; i++) {
      final startX = i * tabWidth - _scrollController.offset;
      // 定义关闭图标区域
      if (widget.isCloseable! &&
          Rect.fromLTWH(startX + closeIconOffset, 0, tabHeight, tabHeight)
              .contains(details.localPosition)) {
        _stateController.closeIndex = i;
        _stateController.pressedIndex = -1;
        return;
      }

      // 定义按钮区域
      if (Rect.fromLTWH(startX, 0, closeIconOffset, tabHeight)
          .contains(details.localPosition)) {
        _stateController.pressedIndex = i;
        _stateController.closeIndex = -1;
        widget.tabController.setSelectedIndex(_stateController.pressedIndex);
        if (widget.onTabClick != null) {
          widget.onTabClick!(
              widget.tabController.items[_stateController.pressedIndex],
              _stateController.pressedIndex,
              details.localPosition);
        }
        return;
      }
    }

    // 默认处理
    _stateController.closeIndex = -1;
    _stateController.pressedIndex = -1;
  }

  // 处理鼠标右键按下事件
  void _onSecondaryTapDown(TapDownDetails details) {
    final tabWidth = widget.tabWidth!;
    final tabHeight = widget.tabHeight!;

    for (int i = 0; i < widget.tabController.items.length; i++) {
      final startX = i * tabWidth - _scrollController.offset;
      // 定义按钮区域
      if (Rect.fromLTWH(startX, 0, tabWidth, tabHeight)
          .contains(details.localPosition)) {
        _stateController.rightIndex = i;
        return;
      }
    }

    // 默认处理
    _stateController.rightIndex = -1;
  }

  // 处理鼠标右键抬起事件
  void _onSecondaryTapUp(TapUpDetails details) {
    if (_stateController.rightIndex != -1) {
      assert(_stateController.rightIndex >= 0 &&
          _stateController.rightIndex < widget.tabController.items.length);
      if (widget.onTabRightClick != null) {
        widget.onTabRightClick!(
            widget.tabController.items[_stateController.rightIndex],
            _stateController.rightIndex,
            details.localPosition);
      }
    }
    _stateController.rightIndex = -1;
  }

  // 处理鼠标抬起事件
  void _onTapUp(TapUpDetails details) {
    if (_stateController.closeIndex != -1) {
      assert(_stateController.closeIndex >= 0 &&
          _stateController.closeIndex < widget.tabController.items.length);

      if (widget.onTabClose != null && widget.isCloseable!) {
        var item = widget.tabController.removeItem(_stateController.closeIndex);
        if (widget.onTabClose != null && item != null) {
          widget.onTabClose!(
              item, _stateController.closeIndex, details.localPosition);
        }
      }
    }
    _stateController.pressedIndex = -1;
    _stateController.closeIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
          onTapDown: _onTapDown,
          onSecondaryTapDown: _onSecondaryTapDown,
          onSecondaryTapUp: _onSecondaryTapUp,
          onTapUp: _onTapUp,
          onTapCancel: () => _stateController.pressedIndex = -1,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: MouseRegion(
                onHover: (event) {
                  _updateHoveredIndex(event.localPosition);
                  _updateHoveredIconIndex(event.localPosition);
                },
                onExit: (event) {
                  _stateController.hoveredIndex = -1;
                },
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  controller: _scrollController,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 5),
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    clipBehavior: Clip.none,
                    child: CustomPaint(
                      size: Size(
                          widget.tabController.items.length * widget.tabWidth!,
                          widget.tabHeight!), // 设置画布大小
                      painter: TabBarPainter(
                          key: widget.key,
                          selectedIndex: widget.tabController.selectedIndex,
                          items: widget.tabController.items,
                          theme: widget.theme ??
                              (Theme.of(context).brightness == Brightness.dark
                                  ? TabBarThemeData.dark
                                  : TabBarThemeData.light),
                          tabWidth: widget.tabWidth!,
                          tabHeight: widget.tabHeight!,
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height,
                          isCloseable: widget.isCloseable!,
                          borderRadius: widget.borderRadius!,
                          stateController: _stateController,
                          scrollController: _scrollController),
                    ),
                  ),
                )),
          ));
    });
  }
}

// TabBar的绘制类
class TabBarPainter extends CustomPainter {
  final GlobalKey key;
  final StateController stateController;
  final ScrollController scrollController;
  final BorderRadius borderRadius;
  final TabBarThemeData theme;
  final List<TabItem> items;
  final int selectedIndex;
  final double tabWidth;
  final double tabHeight;
  final bool isCloseable;
  final double maxWidth;
  final double maxHeight;

  TabBarPainter({
    required this.key,
    required this.items,
    required this.stateController,
    required this.scrollController,
    required this.theme,
    required this.selectedIndex,
    required this.tabWidth,
    required this.tabHeight,
    required this.maxWidth,
    required this.maxHeight,
    required this.isCloseable,
    this.borderRadius = BorderRadius.zero,
  });

  Offset _getPainterPosition() {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) {
      return;
    }
    size = Size(tabWidth * items.length, tabHeight);
    final rrect = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final Paint paint = Paint()
      ..color = theme.backgroundColor!
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
    paint.color = theme.borderColor!;
    paint.style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, paint);

    for (int i = 0; i < items.length; i++) {
      _drawItem(canvas, i, items[i], i == stateController.hoveredIndex,
          i == stateController.pressedIndex);
    }
  }

  void _drawLeadingIcon(
      Canvas canvas, Offset offset, TabItem item, int index, Color color) {
    if (item.icon == null) {
      return;
    }
    var icon = item.icon!;
    TextPainter iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 16.0, fontFamily: icon.fontFamily, color: color));
    iconPainter.layout();
    iconPainter.paint(
        canvas,
        offset +
            Offset((tabHeight - iconPainter.width) / 2,
                (tabHeight - iconPainter.height) / 2));
  }

  // 绘制关闭按钮
  void _drawCloseButton(
      Canvas canvas, Offset offset, int index, Color color, Color fillColor) {
    if ((stateController.hoveredIndex == index) &&
        stateController.hoveredIcon) {
      canvas.drawCircle(
          offset + Offset(tabWidth - tabHeight / 2, tabHeight / 2),
          10,
          Paint()..color = theme.closeIconColor!);
    }

    const icon = Icons.close;
    TextPainter iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 16.0, fontFamily: icon.fontFamily, color: color));
    iconPainter.layout();
    iconPainter.paint(
        canvas,
        offset +
            Offset(tabWidth - tabHeight + (tabHeight - iconPainter.width) / 2,
                (tabHeight - iconPainter.height) / 2));
  }

  // 绘制文本
  void _drawText(
      Canvas canvas, Offset offset, String text, Color color, bool hasIcon) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr, maxLines: 1, ellipsis: "...");
    textPainter.text = TextSpan(text: text, style: TextStyle(color: color));
    textPainter.layout(maxWidth: tabWidth - tabHeight - 10);
    textPainter.paint(
        canvas,
        offset +
            Offset(
                (tabWidth - tabHeight - textPainter.width + 10) / 2 +
                    (hasIcon ? tabHeight / 2 : 0),
                (tabHeight - textPainter.height) / 2));
  }

  // 绘制TabItem
  void _drawItem(
      Canvas canvas, int index, TabItem item, bool isHovered, bool isPressed) {
    Offset offset = Offset(index * tabWidth, 0.0);
    Color fillColor = Colors.transparent;
    Color textColor = theme.textColor!;
    if (isPressed || isHovered) {
      fillColor = theme.hoverBackgroundColor!;
      textColor = theme.hoverTextColor!;
    }
    if (index == selectedIndex) {
      fillColor = theme.activeBackgroundColor!;
      textColor = theme.activeTextColor!;
    }

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = const Color.fromARGB(255, 233, 233, 233)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final Rect rect = Rect.fromLTWH(offset.dx, offset.dy, tabWidth, tabHeight);
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: index == 0 ? borderRadius.topLeft : Radius.zero,
            topRight:
                index == items.length - 1 ? borderRadius.topRight : Radius.zero,
            bottomLeft: index == 0 ? borderRadius.bottomLeft : Radius.zero,
            bottomRight: index == items.length - 1
                ? borderRadius.bottomRight
                : Radius.zero),
        fillPaint);
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: index == 0 ? borderRadius.topLeft : Radius.zero,
            topRight:
                index == items.length - 1 ? borderRadius.topRight : Radius.zero,
            bottomLeft: index == 0 ? borderRadius.bottomLeft : Radius.zero,
            bottomRight: index == items.length - 1
                ? borderRadius.bottomRight
                : Radius.zero),
        strokePaint);
    _drawLeadingIcon(canvas, offset, item, index, theme.iconColor!);
    _drawText(canvas, offset, item.label, textColor, item.icon != null);
    if ((isHovered || selectedIndex == index) && isCloseable) {
      _drawCloseButton(canvas, offset, index, textColor, fillColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

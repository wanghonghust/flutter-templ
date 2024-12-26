import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabController tabController = TabController(selectedIndex: 0, items: [
    TabItem(id: "1", label: "Tab 1"),
    TabItem(id: "2", label: "Tab 2"),
    TabItem(id: "3", label: "Tab 3"),
  ]);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    String id = Uuid().v4().toString();
                    tabController.addItem(
                        TabItem(
                            id: id,
                            label: "Tab ${tabController.items.length + 1}"),
                        selectLast: false);
                  },
                  icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () {
                    tabController.removeItem(0);
                  },
                  icon: const Icon(Icons.remove)),
              IconButton(
                  onPressed: () {
                    var item = tabController.getItemById("1");
                    print(item);
                  },
                  icon: const Icon(Icons.search)),
              Expanded(
                  child: CustomTabBar(
                tabController: tabController,
                tabHeight: 32,
                tabWidth: 80,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem {
  String id;
  String label;
  dynamic data;
  TabItem({required this.id, required this.label, this.data});
}

class TabController extends ChangeNotifier {
  int selectedIndex;
  List<TabItem> items;

  TabController({required this.selectedIndex, required this.items}) {
    if (hasDuplicateIds()) {
      throw Exception("Id is not unique");
    }
  }

  bool hasDuplicateIds() {
    Set<String> ids = {};
    for (var item in items) {
      if (!ids.add(item.id)) {
        return true;
      }
    }
    return false;
  }

  bool _isIdUnique(String id) {
    return !items.any((item) => item.id == id);
  }

  TabItem? getItemById(String id) {
    for (var item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  void selectItemById(String id) {
    int index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      setSelectedIndex(index);
    }
  }

  void setSelectedIndex(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

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

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      if (selectedIndex < 0 || selectedIndex >= items.length) {
        selectedIndex = items.length - 1;
      }
      notifyListeners();
    }
  }

  void removeItemById(String id) {
    items.removeWhere((item) => item.id == id);
    if (selectedIndex < 0 || selectedIndex >= items.length) {
      selectedIndex = items.length - 1;
    }
    notifyListeners();
  }
}

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final double? tabWidth;
  final double? tabHeight;
  final Function(TabItem item, int index)? onTabClick;
  const CustomTabBar(
      {super.key,
      required this.tabController,
      this.onTabClick,
      this.tabWidth = 80,
      this.tabHeight = 32});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late ValueNotifier<int> hoveredIndex;
  late ValueNotifier<int> pressedIndex;
  late ValueNotifier<int> hoveredIconIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    hoveredIndex = ValueNotifier<int>(-1);
    pressedIndex = ValueNotifier<int>(-1);
    hoveredIconIndex = ValueNotifier<int>(-1);
    _tabController = widget.tabController;
    // 监听 TabController 的变化
    _tabController.addListener(() {
      setState(() {}); // 更新 UI
    });
  }

  @override
  void dispose() {
    // 移除监听器
    _tabController.removeListener(() {});
    hoveredIndex.dispose();
    pressedIndex.dispose();
    super.dispose();
  }

  void _updateHoveredIndex(Offset position) {
    for (int i = 0; i < _tabController.items.length; i++) {
      double startX = i * widget.tabWidth!;
      Rect buttonRect =
          Rect.fromLTWH(startX, 0, widget.tabWidth!, widget.tabHeight!);
      if (buttonRect.contains(position)) {
        setState(() {
          hoveredIndex.value = i;
        });
        return;
      }
    }
    setState(() {
      hoveredIndex.value = -1;
    });
  }

  void _updateHoveredIconIndex(Offset position) {
    for (int i = 0; i < _tabController.items.length; i++) {
      double startX = (i + 1) * widget.tabWidth! - widget.tabHeight!;
      if (startX < 0) {
        return;
      }
      Rect closeIconRect =
          Rect.fromLTWH(startX, 0, widget.tabHeight!, widget.tabHeight!);
      if (closeIconRect.contains(position)) {
        setState(() {
          hoveredIconIndex.value = i;
          print("on close button ,hoveredIconIndex: $i");
        });
        return;
      }
    }
    setState(() {
      hoveredIconIndex.value = -1;
      print("hoveredIconIndex: ${hoveredIconIndex.value}");
    });
  }

  void _onTapDown(TapDownDetails details) {
    for (int i = 0; i < _tabController.items.length; i++) {
      double startX = i * widget.tabWidth!;
      Rect buttonRect =
          Rect.fromLTWH(startX, 0, widget.tabWidth!, widget.tabHeight!);
      if (buttonRect.contains(details.localPosition)) {
        setState(() {
          pressedIndex.value = i;
        });
        _tabController.setSelectedIndex(i);
        return;
      }
    }
    setState(() {
      pressedIndex.value = -1;
    });
  }

  void _onTapUp(TapUpDetails details) {
    if (pressedIndex.value != -1 && pressedIndex.value == hoveredIndex.value) {
      assert(pressedIndex.value >= 0 &&
          pressedIndex.value < _tabController.items.length);
      if (widget.onTabClick != null) {
        widget.onTabClick!(
            _tabController.items[pressedIndex.value], pressedIndex.value);
      }
    }
    pressedIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => pressedIndex.value = -1,
      child: MouseRegion(
        onHover: (event) {
          _updateHoveredIndex(event.localPosition);
          _updateHoveredIconIndex(event.localPosition);
        },
        onExit: (event) => _updateHoveredIndex(event.localPosition),
        child: CustomPaint(
          size: Size(_tabController.items.length * widget.tabWidth!,
              widget.tabHeight!), // 设置画布大小
          painter: ButtonRowPainter(
              selectedIndex: _tabController.selectedIndex,
              items: _tabController.items,
              backgroundColor: Colors.white,
              tabWidth: widget.tabWidth!,
              tabHeight: widget.tabHeight!,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              hoveredIndex: hoveredIndex.value,
              pressedIndex: pressedIndex.value,
              hoveredIconIndex: hoveredIconIndex.value),
        ),
      ),
    );
  }
}

class ButtonRowPainter extends CustomPainter {
  final int hoveredIndex;
  final int pressedIndex;
  final int hoveredIconIndex;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<TabItem> items;
  final int selectedIndex;
  final double tabWidth;
  final double tabHeight;

  ButtonRowPainter(
      {required this.items,
      required this.hoveredIndex,
      required this.pressedIndex,
      required this.hoveredIconIndex,
      required this.backgroundColor,
      required this.selectedIndex,
      required this.tabWidth,
      required this.tabHeight,
      this.borderRadius = BorderRadius.zero});

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
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
    paint.color = const Color.fromARGB(255, 228, 231, 237);
    paint.style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, paint);

    // canvas.drawShadow(
    //   Path()..addRRect(rrect),
    //   Colors.black.withOpacity(0.5),
    //   10.0,
    //   true,
    // );
    for (int i = 0; i < items.length; i++) {
      _drawItem(canvas, i, items[i], i == hoveredIndex, i == pressedIndex);
    }
  }

  void _drawCloseButton(
      Canvas canvas, Offset offset, int index, Color color, Color fillColor) {
    canvas.drawCircle(
        offset + Offset(tabWidth - tabHeight / 2, tabHeight / 2),
        10,
        Paint()
          ..color = hoveredIconIndex == hoveredIndex
              ? const Color.fromARGB(255, 79, 125, 184)
              : fillColor);

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
            Offset(tabWidth - tabHeight + iconPainter.width / 2,
                (tabHeight - iconPainter.height) / 2));
  }

  void _drawText(Canvas canvas, Offset offset, String text, Color color) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text =
        TextSpan(text: text, style: TextStyle(fontSize: 12.0, color: color));
    textPainter.layout();
    textPainter.paint(
        canvas, offset + Offset(24, (tabHeight - textPainter.height) / 2));
  }

  void _drawItem(
      Canvas canvas, int index, TabItem item, bool isHovered, bool isPressed) {
    Offset offset = Offset(index * tabWidth, 0.0);
    Color fillColor = Colors.transparent;
    Color textColor = Colors.black;
    if (isPressed || isHovered || index == selectedIndex) {
      fillColor = Colors.blue[400]!;
      textColor = Colors.white;
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
    _drawText(canvas, offset, item.label, textColor);
    if (isHovered) {
      _drawCloseButton(canvas, offset, index, textColor, fillColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate.runtimeType != runtimeType ||
        hoveredIndex != (oldDelegate as ButtonRowPainter).hoveredIndex ||
        pressedIndex != oldDelegate.pressedIndex;
  }
}

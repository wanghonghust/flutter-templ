import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kms/widget/tab_container/index.dart' as tab;

class TabTestPage extends StatefulWidget {
  const TabTestPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return TabTestPageState();
  }
}

class TabTestPageState extends State<TabTestPage>
    with TickerProviderStateMixin {
  tab.TabController controller = tab.TabController(items: [
    tab.TabItem(label: "Tab1", icon: Icons.home, id: "1", toolTip: "Home"),
    tab.TabItem(label: "Tab2", icon: Icons.search, id: "2", toolTip: "Search"),
    tab.TabItem(label: "Tab3", icon: Icons.abc, id: "3", toolTip: "ABC"),
    tab.TabItem(
        label: "Tab4", icon: Icons.dangerous, id: "4", toolTip: "Dangerous"),
    tab.TabItem(
        label: "Tab5",
        icon: Icons.sensor_door,
        id: "5",
        toolTip: "Sensor Door"),
    tab.TabItem(
        label: "Tab6", icon: Icons.settings, id: "6", toolTip: "Settings"),
  ], selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  controller.addItem(tab.TabItem(
                      label: "Tab${controller.items.length + 1}",
                      icon: Icons.add,
                      id: "${controller.items.length + 1}"));
                },
                icon: const Icon(Icons.add)),
            TabView(
              controller: controller,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              borderColor: Theme.of(context).primaryColor,
              borderWidth: 1,
              closeable: true,
            )
          ],
        ),
      ),
    );
  }
}

class TabView extends StatefulWidget {
  final double? height;
  final double? maxWidth;
  final tab.TabController controller;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? selectedColor;
  final Color? hoverColor;
  final bool? closeable;
  const TabView({
    super.key,
    required this.controller,
    this.height = 32,
    this.maxWidth = 100,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.borderWidth = 1,
    this.borderColor = Colors.black,
    this.selectedColor,
    this.hoverColor,
    this.closeable = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _TabViewState();
  }
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.controller.addListener(_onSelected);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSelected);
    super.dispose();
  }

  void _onSelected() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    widget.controller.items.asMap().forEach((index, item) {
      BorderRadius? borderRadius;
      Border? border;
      if (widget.borderRadius != null) {
        if (widget.controller.items.length == 1) {
          borderRadius = widget.borderRadius!;
        } else if (index == 0) {
          borderRadius = BorderRadius.only(
              topLeft: widget.borderRadius!.topLeft,
              bottomLeft: widget.borderRadius!.bottomLeft);
          border = Border(
              right: BorderSide(
                  color: widget.borderColor!, width: widget.borderWidth! / 2));
        } else if (index == widget.controller.items.length - 1) {
          borderRadius = BorderRadius.only(
              topRight: widget.borderRadius!.topRight,
              bottomRight: widget.borderRadius!.bottomRight);
          border = Border(
              left: BorderSide(
                  color: widget.borderColor!, width: widget.borderWidth! / 2));
        } else {
          border = Border(
              left: BorderSide(
                  color: widget.borderColor!, width: widget.borderWidth! / 2),
              right: BorderSide(
                  color: widget.borderColor!, width: widget.borderWidth! / 2));
        }
      }

      children.add(TabWidget(
        title: item.label,
        toolTip: item.toolTip,
        leading: Icon(
          item.icon,
        ),
        closeable: widget.closeable!,
        onClose: () {
          widget.controller.removeItem(index);
        },
        onClick: () {
          widget.controller.setSelectedIndex(index);
        },
        height: widget.height!,
        maxWidth: widget.maxWidth!,
        borderRadius: borderRadius,
        border: border,
        selected: index == widget.controller.selectedIndex,
        selectedColor: widget.selectedColor ?? Theme.of(context).primaryColor,
        hoverColor: widget.hoverColor ?? Theme.of(context).hoverColor,
      ));
    });
    return Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: MyTabViewWidget(
            borderRadius: widget.borderRadius,
            height: widget.height!,
            maxWidth: widget.maxWidth!,
            borderColor: widget.borderColor!,
            borderWidth: widget.borderWidth!,
            children: children,
          ),
        ));
  }
}

class MyTabViewWidget extends MultiChildRenderObjectWidget {
  BorderRadius? borderRadius;
  double height;
  double maxWidth;
  Color borderColor;
  double borderWidth;
  MyTabViewWidget({
    super.key,
    required super.children,
    this.borderRadius,
    required this.height,
    required this.maxWidth,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  TabRenderBox createRenderObject(BuildContext context) {
    return TabRenderBox(
      borderRadius: borderRadius,
      height: height,
      maxWidth: maxWidth,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TabRenderBox renderObject) {
    renderObject
      ..borderRadius = borderRadius
      ..height = height
      ..maxWidth = maxWidth;
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _TabViewElement(this);
  }
}

class _TabViewElement extends MultiChildRenderObjectElement {
  _TabViewElement(MultiChildRenderObjectWidget widget) : super(widget);

  @override
  void insertRenderObjectChild(RenderObject child, dynamic slot) {
    final parentData =
        child.parentData as BoxParentData? ?? TabLayoutParentData();
    child.parentData = parentData;
    super.insertRenderObjectChild(child, slot);
  }
}

class TabLayoutParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = false;
  bool selected = false;

  /// Resets all values.
  void reset() {
    visible = false;
    selected = false;
  }
}

class TabRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TabLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TabLayoutParentData> {
  BorderRadius? borderRadius;
  double height;
  double maxWidth;
  Color borderColor;
  double borderWidth;

  TabRenderBox({
    this.borderRadius,
    required this.height,
    required this.maxWidth,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void performLayout() {
    double offsetX = 0;

    // Layout children
    for (RenderBox child in getChildrenAsList()) {
      child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
          parentUsesSize: true);
      final TabLayoutParentData childParentData =
          child.parentData! as TabLayoutParentData;
      childParentData.offset = Offset(offsetX, 0);
      offsetX += child.size.width;
    }

    // Set the size of the TabRenderBox
    size = Size(offsetX, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var children = getChildrenAsList();
    if (children.isEmpty) return;
    final rrect = RRect.fromRectAndCorners(
      offset & size,
      topLeft: borderRadius != null ? borderRadius!.topLeft : Radius.zero,
      topRight: borderRadius != null ? borderRadius!.topRight : Radius.zero,
      bottomLeft: borderRadius != null ? borderRadius!.bottomLeft : Radius.zero,
      bottomRight:
          borderRadius != null ? borderRadius!.bottomRight : Radius.zero,
    );

    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    context.canvas.drawRRect(rrect, paint);

    for (RenderBox child in children) {
      final TabLayoutParentData childParentData =
          child.parentData! as TabLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }
}

class TabWidget extends StatelessWidget {
  final String title;
  final String? toolTip;
  final Widget? leading;
  final bool? closeable;
  final double? height;
  final double? maxWidth;
  final Function? onClick;
  final Function? onClose;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool? selected;
  final Color? selectedColor;
  final Color? hoverColor;

  TabWidget({
    super.key,
    required this.title,
    this.toolTip,
    this.leading,
    this.closeable = true,
    this.height = 32,
    this.maxWidth = 100,
    this.onClick,
    this.onClose,
    this.borderRadius,
    this.border,
    this.selected = false,
    this.selectedColor,
    this.hoverColor,
  }) {
    if (closeable! && onClose == null) {
      throw Exception("Closeable is true but onClose is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        borderRadius: borderRadius,
        hoverColor: hoverColor,
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: border,
              color: selected! ? selectedColor : Colors.transparent),
          constraints: const BoxConstraints(maxWidth: 100),
          height: height,
          child: Row(
            children: [
              Expanded(
                  child: Tooltip(
                      message: toolTip ?? "",
                      waitDuration: const Duration(seconds: 1),
                      verticalOffset: 18,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          leading!,
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                              child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ))
                        ],
                      ))),
              if (closeable!)
                Tooltip(
                  verticalOffset: 14,
                    message: "Close Tab",
                    waitDuration: const Duration(seconds: 1),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 24,
                      height: 24,
                      child: IconButton(
                        hoverColor: Theme.of(context).hoverColor.withAlpha(50),
                        onPressed: () {
                          if (onClose != null) {
                            onClose!();
                          }
                        },
                        padding: const EdgeInsets.all(4),
                        icon: const Icon(Icons.close),
                        iconSize: 16,
                      ),
                    ))
            ],
          ),
        ),
      );
    });
  }
}

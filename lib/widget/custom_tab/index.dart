import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomButtonContainer extends MultiChildRenderObjectWidget {
  const CustomButtonContainer({
    super.key,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomButtonRenderBox(context: context);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant CustomButtonRenderBox renderObject) {
    renderObject
    ..context = context;
  }
}

class CustomButtonRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomButtonParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomButtonParentData> {
  CustomButtonRenderBox({required BuildContext context}) : _context = context;
  BuildContext get context => _context;
  BuildContext _context;
  set context(BuildContext value) {
    if (value == _context) return;
    _context = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomButtonParentData) {
      child.parentData = CustomButtonParentData();
    }
  }

  @override
  void performLayout() {
    // 计算按钮的总宽度
    double totalWidth = 0;
    final buttonHeight = 40.0; // 每个按钮的高度

    // 计算每个子节点的大小并累加宽度
    RenderBox? child = firstChild;
    while (child != null) {
      // 通过约束进行布局，确保子组件在尺寸计算时有正确的限制
      child.layout(BoxConstraints.loose(constraints.biggest),
          parentUsesSize: false);
      totalWidth += child.getMaxIntrinsicWidth(0.0) + 10.0; // 为每个按钮增加一些内边距
      child = (child.parentData as CustomButtonParentData).nextSibling;
    }

    // 根据计算出的总宽度和传入的约束设置组件的尺寸
    size = constraints.constrain(Size(totalWidth, buttonHeight));

    // 布局子节点
    child = firstChild;
    double buttonOffsetX = 0; // 初始偏移量
    while (child != null) {
      final CustomButtonParentData childParentData =
          child.parentData as CustomButtonParentData;
      child.layout(BoxConstraints.loose(size), parentUsesSize: false);
      childParentData.offset = Offset(buttonOffsetX, 0); // 设置水平偏移
      buttonOffsetX += child.getMaxIntrinsicWidth(0.0) + 10.0; // 更新下一个按钮的偏移量
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;

    for (var child = firstChild; child != null; child = childAfter(child)) {
      final CustomButtonParentData childParentData =
          child.parentData as CustomButtonParentData;
      isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset? transformed) {
          assert(transformed == position - childParentData.offset);
          return child!.hitTest(result, position: transformed!);
        },
      );
    }

    return isHit;
  }
  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    print("event: $event, entry: $entry");
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // 绘制按钮
    RenderBox? child = firstChild;
    while (child != null) {
      final CustomButtonParentData childParentData =
          child.parentData as CustomButtonParentData;
      context.paintChild(child, offset + childParentData.offset); // 绘制子节点
      child = childParentData.nextSibling;
    }
  }
}

class CustomButtonParentData extends ContainerBoxParentData<RenderBox> {}

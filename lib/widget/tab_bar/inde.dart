import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SimpleContainer extends StatefulWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? hoverColor;
  final BorderRadius? borderRadius;
  final Alignment? alignment;

  const SimpleContainer({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.hoverColor,
    this.borderRadius,
    this.child,
    this.alignment,
  });

  @override
  State<SimpleContainer> createState() => _SimpleContainerState();
}

class _SimpleContainerState extends State<SimpleContainer>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isHovered;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _isHovered = ValueNotifier<bool>(false);

    // 初始化 AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 创建颜色动画
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.hoverColor ?? widget.backgroundColor ?? Colors.transparent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _isHovered.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        if (!_isHovered.value) {
          _isHovered.value = true;
          _controller.forward();
        }
      },
      onExit: (_) {
        if (_isHovered.value) {
          _isHovered.value = false;
          _controller.reverse();
        }
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return SimpleRenderObject(
            alignment: widget.alignment,
            width: widget.width,
            height: widget.height,
            backgroundColor: _colorAnimation.value,
            borderRadius: widget.borderRadius,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class SimpleRenderObject extends SingleChildRenderObjectWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Alignment? alignment;

  const SimpleRenderObject({
    super.key,
    required super.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.alignment,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SimpleRenderBox(
      alignment: alignment,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant SimpleRenderBox renderObject) {
    renderObject
      ..width = width
      ..height = height
      ..backgroundColor = backgroundColor
      ..borderRadius = borderRadius;
  }
}

class SimpleRenderBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  double? width;
  double? height;
  Color? backgroundColor;
  BorderRadius? borderRadius;
  Color? hoverColor;
  Alignment? alignment;

  SimpleRenderBox({
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor = Colors.blue,
    this.alignment = Alignment.center,
  });

  @override
  void performLayout() {
    // 根据设置的宽高或者 constraints 来计算布局尺寸
    final double finalWidth = width ?? constraints.constrainWidth();
    final double finalHeight = height ?? constraints.constrainHeight();

    size = constraints.constrain(Size(finalWidth, finalHeight));

    // 布局子节点
    if (child != null) {
      child!.layout(BoxConstraints.loose(size), parentUsesSize: false);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // 如果尺寸为 0，直接返回
    if (size.isEmpty) return;

    // 绘制背景色
    final paint = Paint()
      ..color = backgroundColor ?? Colors.transparent
      ..style = PaintingStyle.fill;

    final rect = offset & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius?.topLeft ?? Radius.zero,
      topRight: borderRadius?.topRight ?? Radius.zero,
      bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
      bottomRight: borderRadius?.bottomRight ?? Radius.zero,
    );
    context.canvas.drawShadow(
      Path()..addRRect(rrect),
      Colors.black.withOpacity(0.5),
      10.0,
      true,
    );

    context.canvas.drawRRect(rrect, paint);

    // 绘制子组件
    if (child != null) {
      final childSize = child!.size;
      final childOffset = Offset(
        offset.dx +
            (1 + (alignment?.x ?? 0)) * (size.width - childSize.width) / 2,
        offset.dy +
            (1 + (alignment?.y ?? 0)) * (size.height - childSize.height) / 2,
      );
      context.paintChild(child!, childOffset);
    }
  }
}

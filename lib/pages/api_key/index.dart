import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kms/pages/markdown_editor/index.dart';
import 'package:kms/widget/tab_bar/inde.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key, required this.title});
  final String title;

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  bool isScrollable = false;
  bool showNextIcon = true;
  bool showBackIcon = true;

  // Leading icon
  Widget? leading;

  // Trailing icon
  Widget? trailing;

  // Sample data for tabs
  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        child: Text('Tab 1'),
      ),
      content: const Center(child: Text('Content for Tab 1')),
    ),
    TabData(
      index: 2,
      title: const Tab(
        child: Text('Tab 2'),
      ),
      content: MarkdownEditor(),
    ),
    // Add more tabs as needed
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomTabWidget(child: Text("data"),),
    );
  }

  void addTab() {
    setState(() {
      var tabNumber = tabs.length + 1;
      tabs.add(
        TabData(
          index: tabNumber,
          title: Tab(
            child: Text('Tab $tabNumber'),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Dynamic Tab $tabNumber'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => removeTab(tabNumber - 1),
                child: const Text('Remove this Tab'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void removeTab(int id) {
    setState(() {
      tabs.removeAt(id);
    });
  }

  void addLeadingWidget() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          'Adding Icon button Widget \nYou can add any customized widget)'),
    ));

    setState(() {
      leading = Tooltip(
        message: 'Add your desired Leading widget here',
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    });
  }

  void removeLeadingWidget() {
    setState(() {
      leading = null;
    });
  }

  void addTrailingWidget() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          'Adding Icon button Widget \nYou can add any customized widget)'),
    ));

    setState(() {
      trailing = Tooltip(
        message: 'Add your desired Trailing widget here',
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    });
  }

  void removeTrailingWidget() {
    setState(() {
      trailing = null;
    });
  }
}


class CustomTabRenderBox extends RenderObject  with MultiChildRenderObjectWidget {
  double tabWidth = 100.0;
  double tabHeight = 50.0;
  Color tabColor = Colors.blue;



  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()
      ..color = tabColor
      ..style = PaintingStyle.fill;
    context.canvas.drawRect(
      Rect.fromLTWH(offset.dx, offset.dy, tabWidth, tabHeight),
      paint,
    );
  }

  
  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }
  
  @override
  void debugAssertDoesMeetConstraints() {
    // TODO: implement debugAssertDoesMeetConstraints
  }
  
  @override
  // TODO: implement paintBounds
  Rect get paintBounds => throw UnimplementedError();
  
  @override
  void performLayout() {
    // TODO: implement performLayout
  }
  
  @override
  void performResize() {
    // TODO: implement performResize
  }
  
  @override
  // TODO: implement semanticBounds
  Rect get semanticBounds => throw UnimplementedError();
}

class CustomTabWidget extends SingleChildRenderObjectWidget {
  CustomTabWidget({Widget? child})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomTabRenderBox();
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    // Update the render object here if necessary
  }
}
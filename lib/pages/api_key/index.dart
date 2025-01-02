import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];

    tabs.add(TabData(
        text: 'Tab 1asdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadasssssssssssssssa',
        leading: (context, status) => const Icon(Icons.star, size: 16),
        content:
            const Padding(padding: EdgeInsets.all(8), child: Text('Hello'))));
    tabs.add(TabData(
        text: 'Tab 2',
        content: const Padding(
            padding: EdgeInsets.all(8), child: Text('Hello again'))));
    tabs.add(TabData(
        // closable: false,
        text: 'TextField',
        content: const Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
                decoration: InputDecoration(
                    isDense: true, border: OutlineInputBorder()))),
        keepAlive: true));

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabbedViewThemeData();
    themeData.tabsArea
      ..border =
          Border.all(color: const Color.fromARGB(76, 205, 205, 205), width: 1)
      ..middleGap = 0;

    Radius radius = const Radius.circular(0);
    BorderRadiusGeometry? borderRadius = BorderRadius.all(radius);

    themeData.tab
      ..padding = const EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      ..hoverButtonBackground= const BoxDecoration(color: Color.fromARGB(142, 56, 56, 56))
      ..textStyle = const TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis)
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color.fromARGB(255, 255, 255, 255),
          border: const Border(
              left: BorderSide(color: Colors.grey, width: 0.5),
              right: BorderSide(color: Colors.grey, width: 0.5)),
          borderRadius: borderRadius)
      ..selectedStatus.decoration =
          BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: borderRadius)
      ..highlightedStatus.decoration = BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: borderRadius);
    Widget w = TabbedViewTheme(data: themeData, child: tabbedView);
    return Scaffold(
        body: Container(padding: const EdgeInsets.all(32), child: w));
  }
}

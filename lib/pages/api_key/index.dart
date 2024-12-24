import 'package:flutter/material.dart';
import 'package:kms/widget/tab_container/index.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  HeaderDelegate({required this.child});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  @override
  State<ApiKeyPage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<ApiKeyPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(() {
      print("Tab index: ${_controller.index}");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.5)),
      child: TabContainer(
      controller: _controller,
      borderRadius: BorderRadius.zero,
      tabBorderRadius: const BorderRadius.all(Radius.circular(20)),
      color: Theme.of(context).scaffoldBackgroundColor,
      duration: const Duration(seconds: 0),
      selectedTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
      unselectedTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
      tabEdge: TabEdge.top,
      
      tabs: _getTabs3(context),
      children: _getChildren3(context),
    ),);
  }

  List<Widget> _getTabs3(BuildContext context) => <Widget>[
        const Icon(
          Icons.info,
        ),
        const Icon(
          Icons.text_snippet,
        ),
        const Icon(
          Icons.person,
        ),
        const Icon(
          Icons.settings,
        ),
      ];
  List<Widget> _getChildren3(BuildContext context) => <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Info', style: Theme.of(context).textTheme.headlineSmall),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non ex ac metus facilisis pulvinar. In id nulla tellus. Donec vehicula iaculis lacinia. Fusce tincidunt viverra nisi non ultrices. Donec accumsan metus sed purus ullamcorper tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Documents', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(flex: 2),
            const Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Divider(thickness: 1),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Document 1'),
                  ),
                  Divider(thickness: 1),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Document 2'),
                  ),
                  Divider(thickness: 1),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Document 3'),
                  ),
                  Divider(thickness: 1),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(flex: 3),
            const Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('username:'),
                        Text('email:'),
                        Text('birthday:'),
                      ],
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('John Doe'),
                        Text('john.doe@email.com'),
                        Text('1/1/1985'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(flex: 1),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SwitchListTile(
                    title: const Text('Darkmode'),
                    value: false,
                    onChanged: (v) {},
                    secondary: const Icon(Icons.nightlight_outlined),
                  ),
                  SwitchListTile(
                    title: const Text('Analytics'),
                    value: false,
                    onChanged: (v) {},
                    secondary: const Icon(Icons.analytics),
                  ),
                ],
              ),
            ),
          ],
        ),
      ];
}

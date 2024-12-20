import 'package:flutter/material.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  HeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

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

class _PlutoGridExamplePageState extends State<ApiKeyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverPersistentHeader(
            delegate: HeaderDelegate(
              child: Container(color: Colors.red),
            ),
          ),
          SliverPersistentHeader(
            delegate: HeaderDelegate(
              child: Container(color: Colors.blue),
            ),
            pinned: true,
          ),
        ];
      },
      body: ListView.builder(
        itemBuilder: (context, index) => Container(
          height: 100,
          color: Colors.accents[index % Colors.accents.length].shade400,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

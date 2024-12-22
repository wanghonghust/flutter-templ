import 'package:flutter/material.dart';
import 'package:kms/widget/dialog/index.dart';
import 'package:kms/widget/side_bar/drwaer.dart';

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
      body: Container(
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  title: const Text('这是一个自定义 Dialog'),
                  onConfirm: () {
                    // 执行确认操作
                  },
                ),
              );
            },
            child: Text("asdas")),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

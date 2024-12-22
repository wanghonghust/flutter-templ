import 'package:flutter/material.dart';
import './controller.dart';

class SideBarItem {
  final Widget title;
  final Widget? icon;
  const SideBarItem({this.icon, required this.title});
}

class SideBar extends StatefulWidget {
  final List<SideBarItem> items;
  final List<SideBarItem>? footItems;
  final SidebarController controller;
  final double? itemHeight;
  final double? extendedWidth;
  final bool? isDrawer;
  const SideBar(
      {super.key,
      required this.items,
      required this.controller,
      this.itemHeight = 40,
      this.extendedWidth = 200,
      this.isDrawer = false,
      this.footItems = const []});

  @override
  State<StatefulWidget> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 200);
  final Curve _curve = Curves.ease;
  late Animation<double> animation;
  List<SideBarItem> get items => widget.items;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:Alignment.topLeft,
      child: IconButton(
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              transitionDuration: const Duration(milliseconds: 300),
              barrierColor: const Color.fromRGBO(0, 0, 0, 0.7),
              fullscreenDialog: true,
              pageBuilder: (_, __, ___) {
                return Stack(
                  children: [
                    // 为了实现 drawer 关闭动画不能直接借助 barrierDismissible  来控制点击遮罩层
                    GestureDetector(onTap: () => {Navigator.of(context).pop()}),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: SizedBox(
                              width: widget.extendedWidth, child: _buildNavigationBar(context)),
                        );
                      },
                    ),
                  ],
                );
              },
            ));
          },
          icon: Icon(Icons.menu)),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: AnimatedContainer(
          width: widget.controller.extended
              ? widget.extendedWidth!
              : (widget.itemHeight! + 10),
          duration: _duration,
          curve: _curve,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: widget.itemHeight,
                        decoration: BoxDecoration(
                          color: widget.controller.selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => setState(() {
                            widget.controller.selectIndex(index);
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: widget.controller.extended
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: widget.items[index].icon!,
                                ),
                                if (widget.controller.extended)
                                  Expanded(
                                    child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: widget.items[index].title),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: widget.footItems!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: widget.itemHeight,
                            decoration: BoxDecoration(
                              color: (widget.controller.selectedIndex -
                                          widget.items.length) ==
                                      widget.footItems!.length - 1 - index
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() {
                                widget.controller.selectIndex(
                                    widget.items.length +
                                        widget.footItems!.length -
                                        index -
                                        1);
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: widget.controller.extended
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: widget
                                          .footItems![widget.footItems!.length -
                                              1 -
                                              index]
                                          .icon!,
                                    ),
                                    if (widget.controller.extended)
                                      Expanded(
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: widget
                                                .footItems![
                                                    widget.footItems!.length -
                                                        1 -
                                                        index]
                                                .title),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              )),
              IconButton(
                onPressed: () {
                  widget.controller.toggleExtended();
                },
                icon: Icon(
                  widget.controller.extended ? Icons.close : Icons.menu,
                ),
              ),
            ],
          ),
        ));
  }
}

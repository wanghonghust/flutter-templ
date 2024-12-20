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
  const SideBar(
      {super.key,
      required this.items,
      required this.controller,
      this.itemHeight = 40,
      this.extendedWidth = 200,
      this.footItems = const []});

  @override
  State<StatefulWidget> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final Duration _duration = const Duration(milliseconds: 200);
  final Curve _curve = Curves.ease;
  @override
  Widget build(BuildContext context) {
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
                        itemCount: widget.footItems!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: widget.itemHeight,
                            decoration: BoxDecoration(
                              color: (widget.controller.selectedIndex - widget.items.length) == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() {
                                widget.controller.selectIndex(index + widget.items.length);
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
                                      child: widget.footItems![index].icon!,
                                    ),
                                    if (widget.controller.extended)
                                      Expanded(
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child:
                                                widget.footItems![index].title),
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

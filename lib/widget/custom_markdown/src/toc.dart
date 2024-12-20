import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Toc {
  String title;
  int level;
  int index;
  Toc({
    required this.title,
    required this.level,
    required this.index,
  });
}

class TocView extends StatefulWidget {
  final List<Toc>? tocList;
  final double? tocWith;
  final ItemScrollController? scrollController;
  final ItemPositionsListener? itemPositionsListener;
  const TocView(
      {super.key,
      this.tocList,
      this.tocWith = 150,
      this.scrollController,
      this.itemPositionsListener});

  @override
  State<StatefulWidget> createState() {
    return _TocViewState();
  }
}

class _TocViewState extends State<TocView> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double _tocWidth =
        (widget.tocWith ?? 150) < 150 ? 150 : widget.tocWith!;
    if (widget.tocList == null) {
      return const SizedBox.shrink();
    }
    widget.itemPositionsListener!.itemPositions.addListener(() {
      final positions = widget.itemPositionsListener!.itemPositions.value;
      if (positions.isNotEmpty) {
        final itemList = positions
            .where((item) => item.itemLeadingEdge >= 0)
            .map((item) => item.index);
        if (itemList.isNotEmpty) {
          final index = itemList.reduce((min, _) => min);
          setState(() {
            for (var i = 0; i < widget.tocList!.length; i++) {
              if (index >= widget.tocList![i].index) {
                _selectedIndex = i;
              }
            }
          });
        }
      }
    });
    return ListView.builder(
      itemCount: widget.tocList!.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            widget.scrollController!.scrollTo(
              index: widget.tocList![index].index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInCubic,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? Theme.of(context).navigationDrawerTheme.indicatorColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: widget.tocList![index].level * 10,
                  height: 24,
                ),
                SizedBox(
                    width: _tocWidth - widget.tocList![index].level * 10,
                    child: LayoutBuilder(builder: (_context, constraints) {
                      TextStyle style = TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).listTileTheme.selectedColor,
                      );
                      final TextPainter textPainter = TextPainter(
                        text: TextSpan(
                            text: widget.tocList![index].title, style: style),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: constraints.maxWidth);

                      final bool isOverflowing = textPainter.didExceedMaxLines;
                      return Tooltip(
                          message:
                              isOverflowing ? widget.tocList![index].title : '',
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.tocList![index].title,
                            style: style,
                          ));
                    }))
              ],
            ),
          ),
        );
      },
    );
  }
}

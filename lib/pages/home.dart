import 'dart:convert';

import 'package:colored_json/colored_json.dart';
import 'package:flutter/material.dart';
import 'package:kms/api/logs.dart';
import 'package:kms/models/logs.dart';
import 'package:kms/models/page_data.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int page = 1;
  List<Log> logs = [];
  PageData<Log>? data;
  bool hasNext = true;
  bool isSmallScreen = false;
  @override
  void initState() {
    super.initState();
    _getLogData();
  }

  Future<void> _getLogData() async {
    if (!hasNext) {
      TDToast.showWarning('没有更多数据了', context: context);
      return;
    }
    data = await getLogs(page.toString(), "10");
    if (data != null && data!.results.isNotEmpty) {
      setState(() {
        logs = [...data!.results, ...logs];
        if (data!.next != null) {
          page++;
        } else {
          hasNext = false;
        }
        TDToast.showSuccess('加载了${data!.results.length}条数据',
            context: context, duration: const Duration(seconds: 1));
      });
    } else {
      hasNext = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      body: _buildRefresh(context),
    );
  }

  Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TDRefreshHeader(loadingIcon: TDLoadingIcon.point),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: _buildLogWidget(logs),
      ),
      // 下拉刷新回调
      onRefresh: () async {
        _getLogData();
      },
    );
  }

  Widget _buildLogWidget(List<Log> logs) {
    if (logs.isEmpty) {
      return const TDEmpty(
        emptyText: '暂无数据',
      );
    }
    List<TDCell> cells = [];
    for (var log in logs) {
      var value = TDCell(
        style: TDCellStyle(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
          backgroundColor: Theme.of(context).hoverColor.withAlpha(10),
          descriptionStyle: const TextStyle(color: Colors.grey),
          borderedColor: Theme.of(context).dividerColor,
          arrowColor: Theme.of(context).primaryColorLight,
        ),
        bordered: true,
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              log.user.username,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Text(
              log.actionTime,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        description: log.message,
        arrow: true,
        image: const AssetImage("assets/avatar.jpg"),
        imageSize: 40,
        onClick: (cell) => {
          Navigator.of(context).push(TDSlidePopupRoute(
              modalBarrierColor: TDTheme.of(context).fontGyColor2,
              isDismissible: true,
              slideTransitionFrom: isSmallScreen
                  ? SlideTransitionFrom.bottom
                  : SlideTransitionFrom.center,
              builder: (context) {
                if (isSmallScreen) {
                  return TDPopupBottomDisplayPanel(
                    title: '${log.user.username} ${log.message}',
                    titleLeft: true,
                    titleColor: Theme.of(context).textTheme.bodyMedium!.color,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 1,
                    closeClick: () {
                      Navigator.maybePop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                              TDTheme.of(context).radiusSmall))),
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ListView(
                        children: [
                          ColoredJson(
                            data: jsonEncode(log.data),
                            squareBracketColor: Theme.of(context).primaryColor,
                            curlyBracketColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return TDPopupCenterPanel(
                    closeClick: () {
                      Navigator.maybePop(context);
                    },
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Theme.of(context).hoverColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                              TDTheme.of(context).radiusSmall))),
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(5),
                      child: ListView(
                        children: [
                          ColoredJson(
                            data: jsonEncode(log.data),
                            squareBracketColor: Theme.of(context).primaryColor,
                            curlyBracketColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  );
                }
              }))
        },
      );
      cells.add(value);
    }

    return TDCellGroup(
      theme: TDCellGroupTheme.cardTheme,
      cells: cells,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kms/api/asymmetric_key.dart';
import 'package:kms/models/asymmetric_key.dart';
import 'package:kms/models/page_data.dart';
import 'package:kms/preferences.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  @override
  State<ApiKeyPage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<ApiKeyPage> {
  int page = 1;
  List<AsymmetricKey> keys = [];
  PageData<AsymmetricKey>? data;
  bool hasNext = true;
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: '产品',
      field: 'product',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: '系列',
      field: 'serial',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: '签名ID',
      field: 'signId',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: '公钥',
      field: 'publicKey',
      type: PlutoColumnType.text(),
      width: 450,
    ),
    PlutoColumn(
      title: '描述',
      field: 'description',
      type: PlutoColumnType.text(),
    )
  ];

  List<PlutoRow> rows = [];

  late final PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final tableConfiguration = themeNotifier.tableConfiguration;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          // columnGroups: columnGroups,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
            stateManager.setShowLoading(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print("change");
          },
          configuration: PlutoGridConfiguration(
            style: tableConfiguration,
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          ),
          // createFooter: (stateManager) {
          //   stateManager.setPageSize(20, notify: false);
          //   return PlutoPagination(stateManager);
          // },
        ),
      ),
    );
  }

  Future<void> _getAsymmetricKeys() async {
    if (!hasNext) {
      TDToast.showWarning('没有更多数据了', context: context);
      return;
    }
    data = await getAsymmetricKeys(page.toString(), "20");
    print(data?.count);
    if (data != null && data!.results.isNotEmpty) {
      setState(() {
        keys = [...data!.results, ...keys];
        if (data!.next != null) {
          page++;
        } else {
          hasNext = false;
        }
      });
    } else {
      setState(() {
        hasNext = false;
      });
      TDToast.showFail('获取失败', context: context);
    }
  }

  void _initData() {
    fetchRows().then((fetchedRows) {
      PlutoGridStateManager.initializeRowsAsync(
        columns,
        fetchedRows,
      ).then((value) {
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(false);
        // stateManager.notifyListeners();
      });
    });
  }

  Future<List<PlutoRow>> fetchRows() async {
    final Completer<List<PlutoRow>> completer = Completer();

    final List<PlutoRow> rows = [];
    await _getAsymmetricKeys();
    for (var item in keys) {
      rows.add(PlutoRow(cells: {
        'product': PlutoCell(value: item.product),
        'serial': PlutoCell(value: item.serial),
        'signId': PlutoCell(value: item.signId),
        'publicKey': PlutoCell(value: item.publicKey),
        'description': PlutoCell(value: item.description),
      }));
    }
    completer.complete(rows);
    return completer.future;
  }
}

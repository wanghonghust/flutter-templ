import 'package:flutter/material.dart';
import 'package:kms/api/asymmetric_key.dart';
import 'package:kms/models/asymmetric_key.dart';
import 'package:kms/models/page_data.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Asymmetric extends StatefulWidget {
  const Asymmetric({Key? key}) : super(key: key);

  @override
  State<Asymmetric> createState() => _AsymmetricState();
}

class _AsymmetricState extends State<Asymmetric> {
  int page = 1;
  List<dynamic> keys = [];
  PageData<AsymmetricKey>? data;
  bool hasNext = true;
  @override
  void initState() {
    super.initState();
    _getAsymmetricKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildRefresh(context));
  }

Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TDRefreshHeader(loadingIcon: TDLoadingIcon.point),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 2, right: 2),
        child: _basicTable(context),
      ),
      // 下拉刷新回调
      onRefresh: () async {
        _getAsymmetricKeys();
      },
    );
  }

  Widget _basicTable(BuildContext context) {
    return TDTable(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      stripe: true,
      columns: [
        TDTableCol(title: '产品', colKey: 'product',sortable: true),
        TDTableCol(title: '系列', colKey: 'serial'),
        TDTableCol(title: '签名ID', colKey: 'sign_id'),
        TDTableCol(title: '公钥', colKey: 'public_key', ellipsis: true),
        TDTableCol(title: '描述', colKey: 'description', ellipsis: true),
      ],
      data: keys,
    );
  }

  void _getAsymmetricKeys() async {
    if (!hasNext) {
      TDToast.showWarning('没有更多数据了', context: context);
      return;
    }
    data = await getAsymmetricKeys(page.toString(), "20");
    if (data != null && data!.results.isNotEmpty) {
      setState(() {
        keys = [...data!.results.map((x) => x.toJson()), ...keys];
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
}

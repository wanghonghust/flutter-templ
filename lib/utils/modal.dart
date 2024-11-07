import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void showModal(BuildContext context, Widget child) {
  SliverWoltModalSheetPage page(BuildContext modalSheetContext) {
    return WoltModalSheetPage(
      backgroundColor:
          Theme.of(modalSheetContext).cardTheme.color?.withOpacity(0.8),
      enableDrag: true,
      topBarTitle: Center(
        child: Text(
            '设置${Theme.of(context).brightness == Brightness.dark ? '暗' : '亮'}模式'),
      ),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: Container(
        margin: const EdgeInsets.all(5),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          iconSize: 20,
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
      ),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.6,
          child: child),
    );
  }

  WoltModalSheet.show(
      context: context,
      enableDrag: true,
      pageListBuilder: (modalSheetContext) {
        return [page(modalSheetContext)];
      },
      modalTypeBuilder: (BuildContext context) {
        return WoltModalType.dialog();
      });
}

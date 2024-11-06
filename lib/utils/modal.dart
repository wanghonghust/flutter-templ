import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void showModal(BuildContext context, Widget child) {
  SliverWoltModalSheetPage page(BuildContext modalSheetContext) {
    return WoltModalSheetPage(
      enableDrag: true,
      topBarTitle: const Center(
        child: Text("设置"),
      ),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.6,
          child: child),
    );
  }

  WoltModalSheet.show(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [page(modalSheetContext)];
      });
}

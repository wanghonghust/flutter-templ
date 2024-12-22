import 'dart:ui';

import 'package:flutter/material.dart';

class CustomDialog extends Dialog {
  final Widget? title;
  final Widget? body;
  final VoidCallback onConfirm;

  const CustomDialog(
      {super.key, required this.title, required this.onConfirm, this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(5),
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(children: [
          Expanded(child: title!),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ]),
      ),
      content: SingleChildScrollView(
        child: Container(
          // 设置颜色和透明度
          width: 800,
          height: 600,
          child: body,
        ),
      ),
    );
  }
}

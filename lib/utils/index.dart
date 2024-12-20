import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kms/models/custom_node.dart';
import 'package:kms/widget/custom_tree/src/treeview.dart' as my_tree;
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> getFileUrl(String fileName) async {
    final directory = await getDownloadsDirectory();
    return "${directory?.path}/$fileName";
  }

  static Future<CustomNode> walkDir(String dirPath) async {
    final directory = Directory(dirPath);
    final List<CustomNode> children = [];

    await for (var entity in directory.list()) {
      if (entity is Directory) {
        // 如果是文件夹，递归调用
        children.add(await walkDir(entity.path));
      } else if (entity is File) {
        // 如果是文件，直接添加为叶子节点
        children.add(CustomNode(entity));
      }
    }
    // 返回当前文件夹节点
    return CustomNode(directory, children);
  }

  static Future<my_tree.TreeNode<FileSystemEntity>> walkDirAsTreeNode(
      String dirPath, BuildContext context) async {
    final directory = Directory(dirPath);
    final List<my_tree.TreeNode<FileSystemEntity>> children = [];

    await for (var entity in directory.list()) {
      if (entity is Directory) {
        // 如果是文件夹，递归调用
        children.add(await walkDirAsTreeNode(entity.path,context));
      } else if (entity is File) {
        // 如果是文件，直接添加为叶子节点
        children.add(my_tree.TreeNode<FileSystemEntity>(
            label: Tooltip(
                waitDuration: const Duration(seconds: 1),
                message: entity.path,
                child: Text(
                  maxLines: 1,
                  Uri.file(entity.path).pathSegments.last,
                  overflow: TextOverflow.ellipsis,
                )),
            value: entity,
            icon: Icon(Icons.description,
                color: Theme.of(context).primaryColor)));
      }
    }
    // 返回当前文件夹节点
    return my_tree.TreeNode<FileSystemEntity>(
        label: Tooltip(
            waitDuration: const Duration(seconds: 1),
            message: directory.path,
            child: Text(
              maxLines: 1,
              Uri.file(directory.path).pathSegments.last,
              overflow: TextOverflow.ellipsis,
            )),
        icon: Icon(Icons.folder, color: Theme.of(context).primaryColor),
        children: children,
        value: directory);
  }
}

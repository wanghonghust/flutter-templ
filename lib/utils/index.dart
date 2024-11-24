import 'dart:io';
import 'dart:math';

import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:kms/models/custom_node.dart';
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

  static Future<Node> walkDirAsNode(String dirPath) async {
    final directory = Directory(dirPath);
   final List<Node> children = [];

  await for (var entity in directory.list()) {
    if (entity is Directory) {
      // 如果是文件夹，递归调用
      children.add(await walkDirAsNode(entity.path));
    } else if (entity is File) {
      // 如果是文件，直接添加为叶子节点
      children.add(Node(label: Uri.file(entity.path).pathSegments.last, key: entity.path,data: entity));
    }
  }
  // 返回当前文件夹节点
  return Node(label: Uri.file(directory.path).pathSegments.last, children: children, key: directory.path,data: directory);
  }
}

import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kms/pages/markdown_editor/hilighter.dart';
import 'package:kms/utils/index.dart';
import 'package:kms/widget/custom_markdown/src/style_sheet.dart';
import 'package:kms/widget/custom_markdown/src/widget.dart';
import 'package:kms/widget/custom_tree/src/treeview.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class FolderTree extends StatefulWidget {
  const FolderTree({super.key});

  @override
  State<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends State<FolderTree> {
  List<TreeNode<FileSystemEntity>> _nodes = [];
  final _treeViewKey = GlobalKey<TreeViewState<FileSystemEntity>>();
  void _onSelectionChanged(List<FileSystemEntity?> selectedValues) {
    print('Selected node values: $selectedValues');
  }


  void _newTab(BuildContext context, String id, String title, Widget widget) {
    final PlutoLayoutEventStreamController? eventStreamController =
        PlutoLayout.getEventStreamController(context);
    bool isExist = false;
    PlutoInsertTabItemResult resolver(
        {required List<PlutoLayoutTabItem> items}) {
          isExist = items.any((item) {
            String id0 = item.id as String;
            return id0 == id;
          });
          print("isExist: $isExist");
      
      return PlutoInsertTabItemResult(
        item: PlutoLayoutTabItem(
          id: id,
          title: title,
          enabled: false,
          showRemoveButton: true,
          tabViewWidget: widget,
        ),
      );
    }
    if (!isExist) {
      
      eventStreamController?.add(PlutoInsertTabItemEvent(
        layoutId: PlutoLayoutId.body,
        itemResolver: resolver,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                top:
                    BorderSide(width: 1, color: Theme.of(context).dividerColor),
                bottom: BorderSide(
                    width: 1, color: Theme.of(context).dividerColor))),
        child: _nodes.isEmpty
            ? IconButton(
                onPressed: () async {
                  var res = await FilePicker.platform.getDirectoryPath();
                  if (res != null && mounted) {
                    Utils.walkDirAsTreeNode(res, context).then((value) {
                      setState(() {
                        _nodes = [value];
                      });
                    });
                  }
                },
                icon: const Icon(Icons.folder_open),
              )
            : _buildFolderTree(_nodes));
  }

  Widget _buildFolderTree(List<TreeNode<FileSystemEntity>> nodes) {
    return TreeView<FileSystemEntity>(
        key: _treeViewKey,
        nodes: nodes,
        onSelectionChanged: _onSelectionChanged,
        expandFirstRootNode: true,
        onNodeTapped: (node) async {
          File file = File(node.value!.path);
          if (await file.exists() && file.path.endsWith('.md')) {
            setState(() {
              String content = file.readAsStringSync();
              _newTab(context, file.path, path.basename(file.path),
                  _buildMarkdown(context, content));
            });
          }
        });
  }

  Widget _buildMarkdown(BuildContext context, String content) {
    return Markdown(
      data: content,
      selectable: true,
      shrinkWrap: true,
      onTapLink: (text, href, title) async {
        Uri url = Uri.parse(href!);
        if (await launchUrl(url)) {}
      },
      imageBuilder: (uri, title, alt) {
        return InkWell(
          onTap: () {
            final imageProvider = Image.network(uri.toString()).image;
            showImageViewer(context, imageProvider, onViewerDismissed: () {});
          },
          child: Image.network(uri.toString()),
        );
      },
      styleSheet: MarkdownStyleSheet(
        horizontalRuleDecoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.5)),
        codeblockDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        blockquoteDecoration: BoxDecoration(
            color: Theme.of(context).hoverColor,
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).primaryColor, width: 4)),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
      ),
      builders: {
        'pre': PreElementBuilder(context),
        'code': CodeElementBuilder(context)
      },
    );
  }
}

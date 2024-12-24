import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kms/pages/key_manager/asymmetric.dart';
import 'package:kms/pages/markdown_editor/folder_tree.dart';
import 'package:kms/pages/markdown_editor/hilighter.dart';
import 'package:kms/utils/index.dart';
import 'package:kms/widget/custom_tree/custom_tree.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kms/widget/custom_markdown/custom_markdown.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({Key? key}) : super(key: key);

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  String content = "";
  List<TreeNode<FileSystemEntity>> _nodes = [];
  final _treeViewKey = GlobalKey<TreeViewState<FileSystemEntity>>();

  void _onSelectionChanged(List<FileSystemEntity?> selectedValues) {
    print('Selected node values: $selectedValues');
  }

  @override
  Widget build(BuildContext context) {
    final MultiSplitViewThemeData themeData = MultiSplitViewThemeData(
        dividerPainter: DividerPainters.grooved1(
            highlightedThickness: 3,
            color: Theme.of(context).primaryColorLight,
            highlightedColor: Theme.of(context).primaryColor));
    var controller = MultiSplitViewController(areas: [
      Area(
          size: 250,
          max: 500,
          min: 150,
          builder: (context, area) => Container(
              decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 10,
                        offset: Offset(0.5, 0.5),
                        spreadRadius: 1),
                  ],
                  border: Border(
                      left: BorderSide(
                          color: Theme.of(context).dividerColor, width: 0.5),
                      right: BorderSide(
                          color: Theme.of(context).dividerColor, width: 0.5))),
              child: MultiSplitView(axis: Axis.vertical, initialAreas: [
                Area(
                  builder: (context, area) => const Asymmetric(),
                ),
                Area(
                  // min: 100,
                  builder: (context, area) => Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor),
                            bottom: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor))),
                    child: TreeView<FileSystemEntity>(
                        key: _treeViewKey,
                        nodes: _nodes,
                        onSelectionChanged: _onSelectionChanged,
                        expandFirstRootNode: true,
                        onNodeTapped: (node) async {
                          File file = File(node.value!.path);
                          if (await file.exists() &&
                              file.path.endsWith('.md')) {
                            setState(() {
                              content = file.readAsStringSync();
                            });
                          }
                        }),
                  ),
                )
              ])),
          data: 'blue'),
      Area(
          flex: 1,
          builder: (context, area) => _buildMarkdown(context),
          data: 'green')
    ]);

    MultiSplitView multiSplitView = MultiSplitView(
      controller: controller,
    );
    MultiSplitViewTheme theme =
        MultiSplitViewTheme(data: themeData, child: multiSplitView);
    return Scaffold(
      body: theme,
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.file_open),
      ),
    );
  }

  Widget _buildMarkdown(BuildContext context) {
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

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String content = "";
  List<TreeNode<FileSystemEntity>> _nodes = [];

  late int _index = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoLayout(
        body: PlutoLayoutContainer(
          child: PlutoLayoutTabsOrChild(
            child: SingleChildScrollView(child: Container()),
          ),
        ),
        left: PlutoLayoutContainer(
          backgroundColor: Colors.transparent,
          child: PlutoLayoutTabs(
            mode: PlutoLayoutTabMode.showOneMust,
            draggable: true,
            tabViewSizeResolver: const PlutoLayoutTabViewSizeConstrains(
              minSize: 100,
            ),
            items: [
              PlutoLayoutTabItem(
                id: "文件夹",
                title: "文件夹",
                sizeResolver: const PlutoLayoutTabItemSizeFlexible(0.7),
                tabViewWidget: const Padding(
                    padding: EdgeInsets.all(15),
                    child: FolderTree()),
              ),
              PlutoLayoutTabItem(
                id: "搜索",
                title: "搜索",
                sizeResolver: const PlutoLayoutTabItemSizeFlexible(0.7),
                tabViewWidget: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text("搜索结果:$_index"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _index++;
                              });
                            },
                            icon: const Icon(Icons.search)),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopTab extends StatefulWidget {
  const TopTab({required this.newTabResolver, super.key});

  final PlutoLayoutActionInsertTabItemResolver newTabResolver;

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  @override
  Widget build(BuildContext context) {
    final PlutoLayoutEventStreamController? eventStreamController =
        PlutoLayout.getEventStreamController(context);

    return TextButton(
        onPressed: () => eventStreamController?.add(
              PlutoInsertTabItemEvent(
                layoutId: PlutoLayoutId.body,
                itemResolver: widget.newTabResolver,
              ),
            ),
        child: Text("New"));
  }
}

import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:kms/models/test.dart';
import 'package:kms/pages/key_manager/asymmetric.dart';
import 'package:kms/pages/markdown_editor/hilighter.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({Key? key}) : super(key: key);

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  @override
  Widget build(BuildContext context) {
    String content = "qwqwe";
    Animal otis = Animal(name: 'Otis');
    Animal zorro = Animal(name: 'Zorro');
    Person lukas = Person(name: 'Lukas', pets: [otis, zorro]);

    List<Node> nodes = [
      Node<Person>(label: 'Lukas', key: 'lukas', data: lukas, children: [
        Node<Animal>(
          label: 'Otis',
          key: 'otis',
          data: otis,
        ),
        //<T> is optional but recommended. If not specified, code can return Node<dynamic> instead of Node<Animal>
        Node(
          label: 'Zorro',
          key: 'zorro',
          data: zorro,
        ),
      ]),
      Node<Person>(label: 'Lukas', key: 'lukas', data: lukas, children: [
        Node<Animal>(
          label: 'Otis',
          key: 'otis',
          data: otis,
        ),
        //<T> is optional but recommended. If not specified, code can return Node<dynamic> instead of Node<Animal>
        Node(
          label: 'Zorro',
          key: 'zorro',
          data: zorro,
        ),
      ]),
      Node<Person>(label: 'Lukas', key: 'lukas', data: lukas, children: [
        Node<Animal>(label: 'Otis', key: 'otis', data: otis, children: [
          Node<Animal>(
            label: 'Otis',
            key: 'otis',
            data: otis,
          ),
        ]),
        //<T> is optional but recommended. If not specified, code can return Node<dynamic> instead of Node<Animal>
        Node(
          label: 'Zorro',
          key: 'zorro',
          data: zorro,
        ),
      ]),
    ];
    TreeViewTheme treeViewTheme = const TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: ExpanderType.chevron,
        modifier: ExpanderModifier.none,
        position: ExpanderPosition.start,
        size: 16,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      iconTheme: IconThemeData(
        size: 18,
      ),
      colorScheme: ColorScheme.light(),
    );
    final TreeViewController treeViewController =
        TreeViewController(children: nodes);

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
                  builder: (context, area) => TreeView(
                    controller: treeViewController,
                    theme: treeViewTheme,
                    nodeBuilder: (context, node) => Text(node.label),
                    onExpansionChanged: (text, expanded) {},
                  ),
                )
              ])),
          data: 'blue'),
      Area(
          flex: 1,
          builder: (context, area) => Markdown(
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
                      final imageProvider = Image.network(uri.toString())
                          .image;
                      showImageViewer(context, imageProvider,
                          onViewerDismissed: () {
                        print("dismissed");
                      });
                    },
                    child: Image.network(uri.toString()),
                  );
                },
                styleSheet: MarkdownStyleSheet(
                    horizontalRuleDecoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade400, width: 0.5)),
                    codeblockDecoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                builders: {'code': CodeElementBuilder(context)},
              ),
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
          var res = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              allowedExtensions: ["md"],
              type: FileType.custom);
          
          if (res != null) {
            setState(() {
              content = File(res.files.first.path!).readAsStringSync();
            });
          }
        },
        child: const Icon(Icons.file_open),
      ),
    );
  }
}

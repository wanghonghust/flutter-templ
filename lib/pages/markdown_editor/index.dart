import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  String content = "";
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
                        color: Colors.black12,
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
                  builder: (context, area) => Asymmetric(),
                ),
                Area(
                    builder: (context, area) => const Draft(
                          text: "text",
                          color: Colors.blue,
                          borderColor: Colors.transparent,
                        ))
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
                      // final imageProvider = Image.network(uri.toString())
                      //     .image;
                      // showImageViewer(context, imageProvider,
                      //     onViewerDismissed: () {
                      //   print("dismissed");
                      // });
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider([
                        const NetworkImage(
                            "https://picsum.photos/id/1001/4912/3264"),
                        const NetworkImage(
                            "https://picsum.photos/id/1003/1181/1772"),
                        const NetworkImage(
                            "https://picsum.photos/id/1004/4912/3264"),
                        const NetworkImage(
                            "https://picsum.photos/id/1005/4912/3264")
                      ]);

                      showImageViewerPager(context, multiImageProvider,
                          onPageChanged: (page) {
                        print("page changed to $page");
                      }, onViewerDismissed: (page) {
                        print("dismissed while on page $page");
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

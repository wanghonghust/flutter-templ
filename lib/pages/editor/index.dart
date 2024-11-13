import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QuillToolbar.simple(
            controller: _controller,
            configurations: const QuillSimpleToolbarConfigurations(
              // embedButtons: FlutterQuillEmbeds.toolbarButtons(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: QuillEditor.basic(
                controller: _controller,
              ),
            ),
          )
        ],
      ),
    );
  }
}

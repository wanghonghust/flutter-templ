import 'package:flutter/material.dart';
import 'package:kms/pages/markdown_editor/index.dart';

class Symmetric extends StatelessWidget {
  const Symmetric({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MarkdownEditor());
  }
}

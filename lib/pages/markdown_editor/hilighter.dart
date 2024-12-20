import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark-reasonable.dart';
import 'package:flutter_highlight/themes/atelier-heath-light.dart';

import 'package:highlighting/languages/dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kms/widget/custom_markdown/src/widget.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  CodeElementBuilder(this.context);
  final BuildContext context;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String _class = element.attributes["class"] ?? '';
    List<String> parts = _class.split('-');
    return HighlightView(
      // The original code to be highlighted
      element.textContent,

      // Specify language
      // It is recommended to give it a value for performance
      language: parts.last,

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: Theme.of(context).brightness == Brightness.light
          ? atelierHeathLightTheme
          : atomOneDarkReasonableTheme,

      // Specify padding
      padding: const EdgeInsets.all(2),

      // Specify text style
      textStyle: GoogleFonts.robotoMono(),
    );
  }
}

class PreElementBuilder extends MarkdownElementBuilder {
  PreElementBuilder(this.context);
  final BuildContext context;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String _class = element.attributes["class"] ?? '';
    List<String> parts = _class.split('-');
    return Row(children: [
      Expanded(
          child: HighlightView(
        // The original code to be highlighted
        element.textContent,

        // Specify language
        // It is recommended to give it a value for performance
        language: parts.last,

        // Specify highlight theme
        // All available themes are listed in `themes` folder
        theme: Theme.of(context).brightness == Brightness.light
            ? atelierHeathLightTheme
            : atomOneDarkReasonableTheme,

        // Specify padding
        padding: const EdgeInsets.all(8),

        // Specify text style
        textStyle: GoogleFonts.robotoMono(),
      ))
    ]);
  }
}

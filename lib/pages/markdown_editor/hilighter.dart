import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/atom-one-dark.dart';
import 'package:flutter_highlighting/themes/atom-one-light.dart';
import 'package:highlighting/languages/dart.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  CodeElementBuilder(this.context);
  final BuildContext context;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return HighlightView(
      // The original code to be highlighted
      element.textContent,

      // Specify language
      // It is recommended to give it a value for performance
      languageId: dart.id,

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: Theme.of(context).brightness == Brightness.light
          ? atomOneLightTheme
          : atomOneDarkTheme,

      // Specify padding
      padding: const EdgeInsets.all(8),

      // Specify text style
      textStyle: GoogleFonts.robotoMono(),
    );
  }
}

import 'package:flutter/material.dart';

class PageInfo {
  final IconData icon;
  final String label;
  final Widget page;

  const PageInfo({
    required this.icon,
    required this.label,
    required this.page,
  });
}

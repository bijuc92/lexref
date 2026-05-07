import 'package:flutter/material.dart';

String truncate(String s, int len) {
  if (s.length <= len) return s;
  return '${s.substring(0, len)}…';
}

List<TextSpan> highlightSearchTerm(
  String text,
  String query, {
  TextStyle? baseStyle,
  TextStyle? highlightStyle,
}) {
  if (query.isEmpty) return [TextSpan(text: text, style: baseStyle)];

  final spans = <TextSpan>[];
  final lower = text.toLowerCase();
  final lowerQuery = query.toLowerCase();
  int start = 0;

  while (true) {
    final idx = lower.indexOf(lowerQuery, start);
    if (idx == -1) {
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
      break;
    }
    if (idx > start) {
      spans.add(TextSpan(text: text.substring(start, idx), style: baseStyle));
    }
    spans.add(TextSpan(
      text: text.substring(idx, idx + query.length),
      style: highlightStyle ??
          baseStyle?.copyWith(fontWeight: FontWeight.bold) ??
          const TextStyle(fontWeight: FontWeight.bold),
    ));
    start = idx + query.length;
  }
  return spans;
}

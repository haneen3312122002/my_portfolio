import 'package:flutter/material.dart';

class AppBodyText extends StatelessWidget {
  const AppBodyText(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  //if no place for the text: ellipsis / fade
  final TextOverflow? overflow;
  //new text line if needed:
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      softWrap: softWrap,
      style: style,
    );
  }
}

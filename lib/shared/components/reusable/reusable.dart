
import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  final focusNode;
  final onTap;
  final controller;
  final style;
  final keyboardType;
  final maxLines;
  final minLines;
  final hintText;
  final disableBorder;
  final hintStyle;
  final fillColor;
  final border;
  final onChanged;
  final validator;
  DefaultFormField({
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.validator,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w800),
    this.maxLines,
    this.minLines,
    this.hintText,
    this.disableBorder=InputBorder.none,
    this.hintStyle,
    this.fillColor ,
    this.border = InputBorder.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      style: style,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hintText,
        disabledBorder: disableBorder,
        hintStyle: hintStyle,
        fillColor: fillColor,
        border: border,
      ),
    );
  }
}



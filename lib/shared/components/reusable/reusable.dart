
import 'package:flutter/material.dart';
import 'package:notes_app/shared/constants.dart';

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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.secondary,
      minLines: minLines,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: hintText,
        disabledBorder: disableBorder,
        hintStyle: hintStyle,
        border: border,
      ),
      // selectionControls: TextSelectionControls(DefaultFormField ,context , ),
    );
  }}

Widget circleProcessInductor(){
  return Center(child: CircularProgressIndicator(color: accentColor,));
}

Widget shadedImage(imgPath){
  return Image.asset(imgPath,
      fit: BoxFit.scaleDown,
      color: Color.fromRGBO(255, 255, 255, 0.5),
      colorBlendMode: BlendMode.modulate);
}
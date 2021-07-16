import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TxtField extends StatelessWidget {
  TxtField(
      {
        this.hintText,
        this.obSecure = false,
        this.readOnly = false,
        this.inputTextFunction,
        this.textInputType = TextInputType.emailAddress,
        this.validatorFun,
        this.showSuffix = false, this.showSuffixFun});

  final hintText;
  final obSecure;
  final readOnly;
  final validatorFun;
  Function? inputTextFunction;
  final TextInputType textInputType;
  final showSuffix;
  final showSuffixFun;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: validatorFun,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(.5),
          ),
          // border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Color(0xff707070).withOpacity(.15)),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.grey.withOpacity(.1),
          filled: true,
          suffixIcon: showSuffix ? IconButton(onPressed: showSuffixFun, icon : Icon( obSecure ? Icons.visibility
              : Icons.visibility_off,size: 20,)) : SizedBox(),
        ),
        keyboardType: textInputType,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: obSecure,
        readOnly: readOnly,
        style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(.8)),
        onChanged: (value) {
          inputTextFunction!(value);
        },
      ),
    );
  }
}
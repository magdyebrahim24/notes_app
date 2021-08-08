import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secrete/secret.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/verify/bloc/state.dart';

class VerifyCubit extends Cubit<VerifyStates> {
  VerifyCubit() : super(VerifyInitialState());

  static VerifyCubit get(context) => BlocProvider.of(context);

  List<int> passwordDigitsList = [];

  String x = '1234';

  void onBuild() {
    checkPass();
  }

  String passwordText = '';
  String? storedPassword;
  bool isCreated = true;

  void checkPass() async {
    String? pass = CacheHelper.getString(key: 'secret_password');
    if (pass != null) {
      storedPassword = pass;
    } else {
      isCreated = false;
    }
    emit(VerifyCheckPassState());
  }

  void addToList(index,context) {
    if (passwordDigitsList.length < 4) {
      passwordDigitsList.add(index + 1);
      print(passwordDigitsList);
      if (passwordDigitsList.length == 4) {
        passwordText = '';
        passwordDigitsList.forEach((element) {
          passwordText = passwordText + element.toString();
        });
        print(storedPassword);
        if (isCreated) {
          if (passwordText == storedPassword) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Secret()));
          } else {
            passwordDigitsList = [];
          }
        } else {
          CacheHelper.putString(key: 'secret_password', value: passwordText);
          print('pass created success ------------');
        }
      }
      emit(VerifyAddToListState());
    }
  }

  void removeFromList() {
    if (passwordDigitsList.isNotEmpty) {
      passwordDigitsList.removeLast();
      print(passwordDigitsList);
      emit(VerifyRemoveFromListState());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/secret.dart';
import 'package:notes_app/layout/verify/bloc/state.dart';
import 'package:notes_app/layout/verify/create_pass.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class LoginCubit extends Cubit<VerifyStates> {
  LoginCubit() : super(VerifyInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  List<int> passwordDigitsList = [];

  String? verifyPass;
  bool isCompleted = false;
  late Database database;

  void onBuild() async {
    var db = await openDatabase('database.db');
    database = db;
    checkPass();
  }

  String passwordText = '';
  String? storedPassword;

  void checkPass() async {
    String? pass = CacheHelper.getString(key: 'secret_password');
    if (pass != null) {
      storedPassword = pass;
      emit(VerifyCheckPassState());
    }

  }

  void loginAndAddToSecret({index, context, id, table,isUpdate}) async{
    if (passwordDigitsList.length < 4) {
      passwordDigitsList.add(index + 1);
      print(passwordDigitsList);
      if (passwordDigitsList.length == 4) {
        passwordText = '';
        passwordDigitsList.forEach((element) {
          passwordText = passwordText + element.toString();
        });
        if (passwordText == storedPassword) {
          if (isUpdate == true) {
           await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CreatePass()));
          }else if(id != null){
           await database.rawQuery('SELECT is_secret FROM $table WHERE id = ?',
                [id]).then((value) async{
              var isSecret = value[0]['is_secret'];
              if (isSecret == 0) {
              await  database.rawUpdate(
                    'UPDATE $table SET is_secret = ? WHERE id = ?',
                    [1, id]);
              } else {
              await  database.rawUpdate(
                    'UPDATE $table SET is_secret = ? WHERE id = ?',
                    [0, id]);
              }
            });
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Secret()));
        } else {
          passwordDigitsList = [];
        }
      }
      emit(VerifyAddToListState());
    }
  }

  void createPassAndAddToSecrete({context, index, id, table}) async{
    if (verifyPass == null) {
      if (passwordDigitsList.length < 4) {
        passwordDigitsList.add(index + 1);
        print(passwordDigitsList);
        print('in create');
        if (passwordDigitsList.length == 4) {
          passwordText = '';
          passwordDigitsList.forEach((element) {
            passwordText = passwordText + element.toString();
          });
          print('pass is created');
          isCompleted = true;
        }
      }
      emit(VerifyAddToListState());
    } else {
      if (passwordDigitsList.length < 4) {
        passwordDigitsList.add(index + 1);
        if (passwordDigitsList.length == 4) {
          passwordText = '';
          passwordDigitsList.forEach((element) {
            passwordText = passwordText + element.toString();
          });
          if (verifyPass == passwordText) {
            if (id != null) {
             await database.rawUpdate('UPDATE $table SET is_secret = ? WHERE id = ?',
                  [1, id]);
            }
          await  CacheHelper.putString(key: 'secret_password', value: passwordText);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Secret()));
          }
        }
      }
      emit(VerifyAddToListState());
    }
  }

  void goToVerify() {
    if (isCompleted == true) {
      verifyPass = passwordText;
      passwordDigitsList = [];
      emit(VerifyGoToVerifyState());
    }
  }

  void z() {
    CacheHelper.sharedPreferences!.remove('secret_password');
  }

  void deleteEnteredPassDigit() {
    if (passwordDigitsList.isNotEmpty) {
      passwordDigitsList.removeLast();
      print(passwordDigitsList);
      emit(VerifyRemoveFromListState());
    }
  }

  @override
  Future<void> close() {
    print('Closed -------------------------------------------------------------');
    return super.close();
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/bloc/state.dart';

class SecretCubit extends Cubit<SecretStates> {
  SecretCubit() : super(SecretInitialState());

  static SecretCubit get(context) => BlocProvider.of(context);

  List<int> password = [];
  String x='1234';

  void addToList(index) {
    if (password.length < 4) {
      password.add(index + 1);
      print(password);
      if (password.length == 4) {
        String m='';
        password.forEach((element) {
          m=m+element.toString();
        });
        print(m);
        if(m==x){
          print('equel');
        }else{
          password=[];
        }
      }
      emit(SecretAddToListState());
    }

  }
  void removeFromList(){
    if(password.isNotEmpty){password.removeLast();
    print(password);
    emit(SecretRemoveFromListState());
    }

  }

}

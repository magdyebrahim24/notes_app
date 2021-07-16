import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/bloc/states/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int counter = 0 ;

  void plusCounter(){
    counter ++ ;
    emit(AppPlusCounterState());
  }


}
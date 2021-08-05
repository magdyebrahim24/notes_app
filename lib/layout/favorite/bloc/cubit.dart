import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/shared/components/gridview.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitialState());
  static FavoriteCubit get(context) => BlocProvider.of(context);

  late Database database ;
  bool isLoading = true;
  List notes = [];
  List tasks = [];
  List memories = [];

  onBuild() async{
    var db = await openDatabase('database.db');
    database = db ;
    // getFavoriteNotes();
    getDataAndRebuild();
  }

  void getDataAndRebuild() async {
    isLoading = true;
    emit(FavoriteLoaderState());
    await getFavoriteNotes();
    isLoading = false;
    emit(FavoriteLoaderState());
  }

  int navBarIndex = 0;

  void onNavBarIndexChange(value) {
    navBarIndex = value;
    emit(FavoriteNavBarIndexState());
  }

  Future getFavoriteNotes() async{
   notes=[];
   await database.rawQuery('SELECT * FROM notes WHERE is_favorite = ?', [1]).then((value) {
      value.forEach((element) {
          notes.add(element);
        print(element);
      });
    });
   print('note --------------');
   print(notes);
tasks=[];
   await database.rawQuery('SELECT * FROM tasks WHERE is_favorite = ?', [1]).then((value) {
     value.forEach((element) {
         tasks.add(element);
       print(element);
     });
   });
   print('task --------------');
   print(tasks);
memories=[];
   await database.rawQuery('SELECT * FROM memories WHERE is_favorite = ?', [1]).then((value) {
     value.forEach((element) {
         memories.add(element);
       print(element);
     });
   });

   print('memory --------------');
   print(memories);

  }

  @override
  Future<void> close() async{
    // await database.close();
    return super.close();
  }

}

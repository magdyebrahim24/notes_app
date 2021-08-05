import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitialState());
  static FavoriteCubit get(context) => BlocProvider.of(context);

  Database? database ;
  onBuild() async{
    var db = await openDatabase('database.db');
    database = db ;
  }

  int navBarIndex = 0;

  void onNavBarIndexChange(value) {
    navBarIndex = value;
    getFavoriteNotes(database);
    emit(FavoriteNavBarIndexState());
  }

  Future getFavoriteNotes(db) async{
   List notes = [];
   List tasks = [];
   List memories = [];
   await db.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        if(element['is_favorite'] == 1){
          notes.add(element);
        }
        print(element);
      });
    });
   print('--------------');
   print(notes);

   await db.rawQuery('SELECT * FROM tasks').then((value) {
     value.forEach((element) {
       if(element['is_favorite'] == 1){
         tasks.add(element);
       }
       print(element);
     });
   });
   print('--------------');
   print(tasks);

   await db.rawQuery('SELECT * FROM memories').then((value) {
     value.forEach((element) {
       if(element['is_favorite'] == 1){
         tasks.add(element);
       }
       print(element);
     });
   });

   print('--------------');
   print(memories);

  }

  @override
  Future<void> close() async{
    await database!.close();
    return super.close();
  }

}

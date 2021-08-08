import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secrete/bloc/states.dart';
import 'package:sqflite/sqflite.dart';

class SecretCubit extends Cubit<SecretStates> {
  SecretCubit() : super(SecretInitialState());

  static SecretCubit get(context) => BlocProvider.of(context);
  late Database database;
  bool isLoading = true;
  List notes = [];
  List tasks = [];
  List memories = [];

  onBuild() async {
    var db = await openDatabase('database.db');
    database = db;
    getSecretNotes();
    // getDataAndRebuild();
    emit(SecretGetDataState());
  }

  Future getSecretNotes() async {
    notes = [];
    await database.rawQuery(
        'SELECT * FROM notes WHERE is_secret = ?', [1]).then((value) {
      value.forEach((element) {
        notes.add(element);
        print(element);
      });
    });
    print('note --------------');
    print(notes);
    tasks = [];
    await database.rawQuery(
        'SELECT * FROM tasks WHERE is_secret = ?', [1]).then((value) {
      value.forEach((element) {
        tasks.add(element);
        print(element);
      });
    });
    print('task --------------');
    print(tasks);
    memories = [];
    await database.rawQuery(
        'SELECT * FROM memories WHERE is_secret = ?', [1]).then((value) {
      value.forEach((element) {
        memories.add(element);
        print(element);
      });
    });

    print('memory --------------');
    print(memories);
  }
}
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/bloc/secret_states.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:sqflite/sqflite.dart';

class SecretCubit extends Cubit<SecretStates> {
  SecretCubit() : super(SecretInitialState());

  static SecretCubit get(context) => BlocProvider.of(context);
  late Database database;
  bool isLoading = true;
  List notes = [];
  List tasks = [];
  List memories = [];
  int navBarIndex = 0;

  TabController? tabBarController;

  onBuild(x) async {
    tabBarController = TabController(length: 3, vsync: x);
    var db = await openDatabase('database.db');
    database = db;
    getDataAndRebuild();
    emit(SecretGetDataState());
  }

  void getDataAndRebuild() async {
    isLoading = true;
    emit(SecretLoaderState());
    await getNotesDataWithItsImages();
    await getAllTasksDataWithItSubTasks();
    await getAllMemoriesDataWithItsImages();
    isLoading = false;
    emit(SecretLoaderState());
  }

  void onNavBarIndexChange(value) {
    navBarIndex = value;
    emit(SecretNavBarIndexState());
  }

  Future getNotesDataWithItsImages() async {
    // get all notes data
    List<Map<String, dynamic>> notesDataList =
        await database.rawQuery('SELECT * FROM notes WHERE is_secret = ?', [1]);

    // get all notes images data
    List cachedNotesImagesList = await database.rawQuery('SELECT notes_images.id,notes_images.link,notes_images.note_id FROM notes_images INNER JOIN notes ON notes.id=notes_images.note_id AND notes.is_secret=? ' ,[1]);

    List recordsList = await database.rawQuery('SELECT voices.id,voices.link,voices.note_id FROM voices INNER JOIN notes ON notes.id=voices.note_id AND notes.is_secret=? ' ,[1]);

    notes = assignSubListToData(
        notesDataList, cachedNotesImagesList, 'images', 'note_id',voices: recordsList,voiceKey: 'voices',voiceId: 'note_id');
    emit(SecretGetDataState());
    return true ;
  }

  Future getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList =
        await database.rawQuery('SELECT * FROM tasks WHERE is_secret = ?', [1]);
    // get all task sub tasks data
    List subTasksList = await database.rawQuery('SELECT subTasks.id,subTasks.body,subTasks.isDone,subTasks.tasks_id FROM subTasks INNER JOIN tasks ON tasks.id=subTasks.tasks_id AND tasks.is_secret=?',[1]);

    tasks = assignSubListToData(
        tasksDataList, subTasksList, 'subTasks', 'tasks_id');
    emit(SecretGetDataState());
  }

  Future getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList =
    await database.rawQuery(
        'SELECT * FROM memories WHERE is_secret = ?', [1]);
    // get memories images
    List cachedMemoriesImagesList =
    await database.rawQuery('SELECT memories_images.id,memories_images.link,memories_images.memory_id FROM memories_images INNER JOIN memories ON memories.id=memories_images.memory_id AND memories.is_secret=? ' ,[1]);

    memories = assignSubListToData(
        memoriesDataList, cachedMemoriesImagesList, 'images', 'memory_id');
    emit(SecretGetDataState());
  }

  void addToFavorite(context,
      {isFavorite, itemId, tableName, itemsList, index,required listOfData}) async{
    Navigator.pop(context);
    showModalBottomSheet<void>(
    barrierColor: Colors.transparent,
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32))),
            margin: EdgeInsets.fromLTRB(34, 7, 34, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 22,top: 17),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5)),
                  height: 3,
                  width: 80,

                ),
                 Text('Add To Favorite',style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 23)),
                 Padding(
                   padding: const EdgeInsets.only(top: 15,bottom: 10),
                   child: Text('Put this item in favorite?',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 17,fontWeight: FontWeight.w300)),
                 ),
                 Text('*Putting this item in Favorite will\ndelete it from the Secret',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 13,fontWeight: FontWeight.w300,height: 1.5),textAlign: TextAlign.center,softWrap: true,),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  TextButton(

                    child:  Text('Close ',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14,fontWeight: FontWeight.w500),),
                    onPressed: () { Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20,),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 32,
                    minWidth: 95,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child:  Text('Favorite',style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 16),),
                      onPressed: () async{
                        List<Map<String, dynamic>> temp = itemsList;
                        Map<String, dynamic> item = temp[index];
                        await favoriteFun(context,database, tableName, isFavorite, itemId,item['is_secret'],insideSecretHome: true);
                        removeFromSecret(context, itemId, tableName, listOfData, index);
                        emit(AddToFavoriteState());
                        showToast('Add to Favorite');
                      }
                  ),
                ],)
              ],
            ),
          );});

  }

  void deleteFun(context, {required int id, tableName, index, listOfData ,recordsList}) async{
    await  deleteOneItem(context, database,
        id: id,
        tableName: tableName,
        cachedImagesList: listOfData,
        recordsList: recordsList ?? [] );
    listOfData.removeAt(index);
    emit(DeleteItemState());
  }


  void removeFromSecret(context, id, tableName, listOfData, index) async {
    await  database.rawUpdate(
        'UPDATE $tableName SET is_secret = ? WHERE id = ?',
        [0, id]);
    listOfData.removeAt(index);
    Navigator.pop(context);
    emit(AddToSecretItemState());
  }

  void upDatePassword(context) {
    bool isUpdated = true;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  isUpdate: isUpdated,
                )));
  }


  int? selectedItemIndex;
  void toggleLongTap(index){
    selectedItemIndex =index;
    emit(ToggleFABState());
  }
}











































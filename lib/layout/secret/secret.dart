import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/note/note_preview.dart';
import 'package:notes_app/layout/secret/bloc/secret_cubit.dart';
import 'package:notes_app/layout/secret/bloc/secret_states.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/layout/task/tasks_preview.dart';
import 'package:notes_app/layout/dashboard/MenuDashboardPage.dart';
import 'package:notes_app/shared/components/bottom_option_bar.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:notes_app/shared/share/share_functions.dart';

class Secret extends StatefulWidget {
  @override
  State<Secret> createState() => _SecretState();
}

class _SecretState extends State<Secret>  with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SecretCubit()..onBuild(this),
      child: BlocConsumer<SecretCubit, SecretStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SecretCubit cubit = SecretCubit.get(context);
          return Scaffold(
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0.0,
                        title: Text(
                          Languages.of(context)!.drawer['secret'],
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        centerTitle: true,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuDashboardPage()));
                          },
                          icon: Icon(Icons.arrow_back_ios,size: 20,),
                        ),
                        actions: [
                          _offsetPopup(
                              context, () => cubit.upDatePassword(context)),
                        ],
                        pinned: true,
                        snap: true,
                        floating: true,
                        expandedHeight: 120,
                        bottom: TabBar(
                          controller: cubit.tabBarController,
                          tabs: [
                            Tab(
                              text: Languages.of(context)!.home['notes'],
                            ),
                            Tab(text: Languages.of(context)!.home['tasks']),
                            Tab(
                              text: Languages.of(context)!.home['memories'],
                            ),
                          ],
                          isScrollable: true,
                          indicatorPadding: EdgeInsets.symmetric(
                            horizontal: 17,
                          ),
                          labelPadding: EdgeInsets.symmetric(horizontal: 25),
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                      controller: cubit.tabBarController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        NotePreview(
                          selectedItemIndex: cubit.selectedItemIndex,
                          data: cubit.notes,
                          onLongPress: (data, index) {
                            cubit.toggleLongTap(index);
                            showOptionBar(context,isSecret: cubit.notes[index]['is_secret'],
                              shareFun: ()=> shareNoteAndMemory(cubit.notes[index]['images']??[]  ,cubit.notes[index]['title'],cubit.notes[index]['body'],'note'),
                                favFun: () => cubit.addToFavorite(context,
                                    listOfData: cubit.notes,
                                    isFavorite: cubit.notes[index]
                                                ['is_favorite'] ==
                                            0
                                        ? false
                                        : true,
                                    itemId: data['id'],
                                    tableName: 'notes',
                                    itemsList: cubit.notes,
                                    index: index),
                                deleteFun: () => cubit.deleteFun(context,
                                    id: data['id'],
                                    tableName: 'notes',
                                    index: index,
                                    listOfData: cubit.notes),
                                secretFun: () => cubit.removeFromSecret(
                                    context,
                                    data['id'],
                                    'notes',
                                    cubit.notes,
                                    index),
                                isFavorite: cubit.notes[index]
                                    ['is_favorite'],onCloseFun: cubit.toggleLongTap,);
                          },
                          navFun: (data) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNote(
                                    data: data,
                                  ),
                                )).then((value) {
                              cubit.getNotesDataWithItsImages();
                            });
                          },
                          isLoading: cubit.isLoading,
                        ),
                        TasksPreview(
                            selectedItemIndex: cubit.selectedItemIndex,
                            body: cubit.tasks,
                            onLongPress: (data, index) {
                              cubit.toggleLongTap(index);
                              showOptionBar(context,isSecret: cubit.tasks[index]['is_secret'],
                                shareFun: ()=> shareTask(cubit.tasks[index]['title'], cubit.tasks[index]['title'], cubit.tasks[index]['taskDate'], cubit.tasks[index]['subTasks'] ?? []),
                                favFun: () => cubit.addToFavorite(context,
                                    listOfData: cubit.tasks,
                                    isFavorite: cubit.tasks[index]
                                    ['is_favorite'] ==
                                        0
                                        ? false
                                        : true,
                                    itemId: data['id'],
                                    tableName: 'tasks',
                                    itemsList: cubit.tasks,
                                    index: index),
                                deleteFun: () => cubit.deleteFun(context,
                                    id: data['id'],
                                    tableName: 'tasks',
                                    index: index,
                                    listOfData: cubit.tasks),
                                secretFun: () => cubit.removeFromSecret(
                                    context,
                                    data['id'],
                                    'tasks',
                                    cubit.tasks,
                                    index),
                                isFavorite: cubit.tasks[index]
                                ['is_favorite'],onCloseFun: cubit.toggleLongTap,);
                            },
                            onTapFun: (data) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTask(
                                      data: data,
                                    ),
                                  )).then((value) {
                                cubit.getAllTasksDataWithItSubTasks();
                              });
                            },
                            // () => cubit.getAllTasksDataWithItSubTasks(),
                            isLoading: cubit.isLoading),
                        MemoriesPreview(
                            selectedItemIndex: cubit.selectedItemIndex,
                            data: cubit.memories,
                            isLoading: cubit.isLoading,
                            onLongPress: (data, index) {
                              cubit.toggleLongTap(index);
                              showOptionBar(context,isSecret: cubit.memories[index]['is_secret'],
                                shareFun: ()=> shareNoteAndMemory(cubit.memories[index]['images'] ?? []  ,cubit.memories[index]['title'],cubit.memories[index]['body'],'memory',memoryDate:cubit.memories[index]['memoryDate'] ),
                                favFun: () => cubit.addToFavorite(context,
                                    listOfData: cubit.memories,
                                    isFavorite: cubit.memories[index]
                                    ['is_favorite'] ==
                                        0
                                        ? false
                                        : true,
                                    itemId: data['id'],
                                    tableName: 'memories',
                                    itemsList: cubit.memories,
                                    index: index),
                                deleteFun: () => cubit.deleteFun(context,
                                    id: data['id'],
                                    tableName: 'memories',
                                    index: index,
                                    listOfData: cubit.memories),
                                secretFun: () => cubit.removeFromSecret(
                                    context,
                                    data['id'],
                                    'memories',
                                    cubit.memories,
                                    index),
                                isFavorite: cubit.memories[index]
                                ['is_favorite'],onCloseFun: cubit.toggleLongTap,);
                            },
                            onTapFun: (data) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMemory(
                                      data: data,
                                    ),
                                  )).then((value) {
                                cubit.getAllMemoriesDataWithItsImages();
                              });
                            }),
                      ]),
                ),
              ),
          );
        },
      ),
    );
  }

  Widget _offsetPopup(context, fun) => PopupMenuButton<int>(
      tooltip: 'More',
      enableFeedback: true,
      onSelected: (value) {
        fun();
      },
      // offset: Offset(-10,45),
      itemBuilder: (context) => [
            PopupMenuItem(
              // padding: EdgeInsets.symmetric(horizontal: 50),
              value: 1,
              child: Text(
                Languages.of(context)!.secret['updatePass'],
                style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
              ),

            ),
          ],
      icon: Icon(
        Icons.more_vert,
        // color: greyColor,
      ));
}

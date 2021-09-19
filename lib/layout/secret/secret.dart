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
                          'Secret',
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
                          icon: Icon(Icons.arrow_back),
                        ),
                        actions: [
                          _offsetPopup(
                              context, () => cubit.upDatePassword(context)),
                        ],
                        pinned: true,
                        snap: false,
                        floating: true,
                        expandedHeight: 120,
                        bottom: TabBar(
                          controller: cubit.tabBarController,
                          tabs: [
                            Tab(
                              text: 'Notes',
                            ),
                            Tab(text: 'Tasks'),
                            Tab(
                              text: 'Memories',
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
                          data: cubit.notes,
                          onLongPress: (data, index) {
                            showOptionBar(context,
                                favFun: () => cubit.addToFavorite(context,
                                    isFavorite: cubit.notes[index]
                                                ['is_favorite'] ==
                                            0
                                        ? false
                                        : true,
                                    noteId: data['id'],
                                    tableName: 'notes',
                                    isFavoriteItem: cubit.notes,
                                    index: index),
                                deleteFun: () => cubit.deleteNote(context,
                                    id: data['id'],
                                    tableName: 'Notes',
                                    index: index,
                                    listOfData: cubit.notes),
                                secretFun: () => cubit.addToSecret(
                                    context,
                                    data['id'],
                                    'notes',
                                    cubit.notes,
                                    index),
                                isFavorite: cubit.notes[index]
                                    ['is_favorite']);
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
                            body: cubit.tasks,
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
                            data: cubit.memories,
                            isLoading: cubit.isLoading,
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
                "Update Password",
              ),
            ),
          ],
      icon: Icon(
        Icons.more_vert,
        // color: greyColor,
      ));
}

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

class Secret extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SecretCubit()..onBuild(),
      child: BlocConsumer<SecretCubit, SecretStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SecretCubit cubit = SecretCubit.get(context);
          List<Widget> bodyList = [
            NotePreview(
              data: cubit.notes,
              navFun: (data) async{
               await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNote(
                        data: data,
                      ),
                    ));
                  cubit.getNotesDataWithItsImages();

              },
              isLoading: cubit.isLoading,
            ),
            TasksPreview(body: cubit.tasks,
                onTapFun: (data) async{
             await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTask(
                      data: data,
                    ),
                  ));
                cubit.getAllTasksDataWithItSubTasks();

            },isLoading:  cubit.isLoading),
            MemoriesPreview(
                data: cubit.memories,
                isLoading: cubit.isLoading,
                onTapFun: (data) async {
                 await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMemory(
                          data: data,
                        ),
                      ));
                    cubit.getAllMemoriesDataWithItsImages();

                }),
          ];
          return Scaffold(
            appBar: AppBar(
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
                _offsetPopup(context,()=>cubit.upDatePassword(context) ),
              ],
            ),
            body: bodyList[cubit.navBarIndex],
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                clipBehavior: Clip.antiAlias,
                child: BottomNavigationBar(
                  showUnselectedLabels: false,
                  currentIndex: cubit.navBarIndex,unselectedIconTheme: IconThemeData(size: 26),
                  onTap: (value) => cubit.onNavBarIndexChange(value),
                  items: [
                    BottomNavigationBarItem(tooltip: 'Notes',
                        icon: Icon(Icons.article_outlined), label: 'Notes'),
                    BottomNavigationBarItem(tooltip: 'Tasks',
                        icon: Icon(Icons.task_outlined), label: 'Tasks'),
                    BottomNavigationBarItem(tooltip: 'Memories',
                        icon: Icon(Icons.event_available_outlined), label: 'Memories'),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
  Widget _offsetPopup(context,fun) => PopupMenuButton<int>(
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

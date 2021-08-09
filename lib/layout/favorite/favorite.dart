import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/cubit.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/note/note_preview.dart';
import 'package:notes_app/layout/task/tasks_preview.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      FavoriteCubit()
        ..onBuild(),
      child: BlocConsumer<FavoriteCubit, FavoriteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FavoriteCubit cubit = FavoriteCubit.get(context);
          List<Widget> bodyList = [
            NotePreview(data: cubit.notes,
              navFun: (data) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNote(
                            data: data,
                          ),
                    )).then((value) {
                  cubit.getNotesDataWithItsImages();
                });
              }, isLoading: cubit.isLoading,),
            TasksPreview(
                cubit.tasks,
                    () => cubit.getAllTasksDataWithItSubTasks(),
                cubit.isLoading),
            MemoriesPreview(
                data: cubit.memories,
                isLoading: cubit.isLoading,
                onTapFun: (data) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddMemory(
                              data: data,
                            ),
                      )).then((value) {
                    cubit.getAllMemoriesDataWithItsImages();
                  });
                }),
          ];
          return Scaffold(
            appBar: AppBar(),
            body: bodyList[cubit.navBarIndex],
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                clipBehavior: Clip.antiAlias,
                child: BottomNavigationBar(
                  showUnselectedLabels: false,
                  selectedIconTheme: IconThemeData(),
                  currentIndex: cubit.navBarIndex,
                  onTap: (value) => cubit.onNavBarIndexChange(value),
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.note_outlined), label: 'Notes'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.task_outlined), label: 'Tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label: 'Memory'),
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
}

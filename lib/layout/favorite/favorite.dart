import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/layout/favorite/bloc/favorite_cubit.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/note/note_preview.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/layout/task/tasks_preview.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FavoriteCubit()..onBuild(),
      child: BlocConsumer<FavoriteCubit, FavoriteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FavoriteCubit cubit = FavoriteCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: cubit.isLoading
                ? Center(child: CircularProgressIndicator())
                : StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: cubit.allData.length,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    itemBuilder: (BuildContext context, int index) {
                      return cubit.allData[index]['type'] == 'note'
                          ? NoteCard(
                              isFavorite: cubit.isFavorite,
                              onTapFun: () {
                                cubit.updateDataWhenGetOut(
                                    context,
                                    AddNote(data: cubit.allData[index]),
                                    cubit
                                        .getNotesDataWithItsImages());
                              },
                              data: cubit.allData[index])
                          : cubit.allData[index]['type'] == 'task'
                              ? TaskCard(
                                  onTapFun: () {
                                    cubit.updateDataWhenGetOut(
                                        context,
                                        AddTask(data: cubit.allData[index]),
                                        cubit
                                            .getAllTasksDataWithItSubTasks());
                                  },
                                  data: cubit.allData[index],
                                  isFavorite: cubit.isFavorite,
                                )
                              : MemoryCard(
                                  noTapFun: () {
                                    cubit.updateDataWhenGetOut(
                                        context,
                                        AddMemory(data: cubit.allData[index]),
                                        cubit
                                            .getAllMemoriesDataWithItsImages());
                                  },
                                  data: cubit.allData[index],
                                  isFavorite: cubit.isFavorite,
                                );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
          );
        },
      ),
    );
  }
}

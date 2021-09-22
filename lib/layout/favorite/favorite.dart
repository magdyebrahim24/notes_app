import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/layout/favorite/bloc/favorite_cubit.dart';
import 'package:notes_app/layout/favorite/bloc/favorite_states.dart';
import 'package:notes_app/layout/favorite/favorite_cards.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/search_screen/search_cards.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

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
            appBar: AppBar(
              title: Text('Favorite'),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                tooltip: 'Back',
              ),
            ),
            body: cubit.isLoading
                ? Center(child: circleProcessInductor())
                : cubit.allData.isNotEmpty
                    ? StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: cubit.allData.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemBuilder: (BuildContext context, int index) {
                          return cubit.allData[index]['type'] == 'note'
                              ? FavoriteNoteCard(
                                  // isFavorite: cubit.isFavorite,
                                  onTapFun: () {
                                    cubit.updateDataWhenGetOut(
                                        context,
                                        AddNote(data: cubit.allData[index]),
                                        cubit.getNotesDataWithItsImages);
                                  },
                                  data: cubit.allData[index])
                              : cubit.allData[index]['type'] == 'task'
                                  ? TaskSearchCard(
                                      isUsedAgain: true,
                                      onTap: () {
                                        cubit.updateDataWhenGetOut(
                                            context,
                                            AddTask(data: cubit.allData[index]),
                                            cubit
                                                .getAllTasksDataWithItSubTasks);
                                      },
                                      data: cubit.allData[index],
                                      // isFavorite: cubit.isFavorite,
                                    )
                                  : FavoriteMemoryCard(
                                      noTapFun: () {
                                        cubit.updateDataWhenGetOut(
                                            context,
                                            AddMemory(
                                                data: cubit.allData[index]),
                                            cubit
                                                .getAllMemoriesDataWithItsImages);
                                      },
                                      data: cubit.allData[index],
                                      // isFavorite: cubit.isFavorite,
                                    );
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(1),
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                      )
                    : shadedImage('assets/intro/memories.png'),
          );
        },
      ),
    );
  }
}

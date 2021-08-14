import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/layout/favorite/bloc/cubit.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/layout/note/note_preview.dart';
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
                              onTapFun: () {cubit.updateDataForGetOutNote(context,cubit.allData[index]);}, data: cubit.allData[index])
                          : cubit.allData[index]['type'] == 'task'
                              ? TaskCard(() {cubit.updateDataForGetOutTask(context,cubit.allData[index]);}, cubit.allData[index])
                              : MemoryCard(() {cubit.updateDataForGetOutMemory(context, cubit.allData[index]);}, cubit.allData[index]);
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
            // body: bodyList[cubit.navBarIndex],
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Material(
            //     borderRadius: BorderRadius.circular(25),
            //     clipBehavior: Clip.antiAlias,
            //     child: BottomNavigationBar(
            //       showUnselectedLabels: false,
            //       selectedIconTheme: IconThemeData(),
            //       currentIndex: cubit.navBarIndex,
            //       onTap: (value) => cubit.onNavBarIndexChange(value),
            //       items: [
            //         BottomNavigationBarItem(
            //             icon: Icon(Icons.note_outlined), label: 'Notes'),
            //         BottomNavigationBarItem(
            //             icon: Icon(Icons.task_outlined), label: 'Tasks'),
            //         BottomNavigationBarItem(
            //             icon: Icon(Icons.archive), label: 'Memory'),
            //       ],
            //     ),
            //   ),
            // ),
            // floatingActionButtonLocation:
            // FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

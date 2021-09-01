import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/note/note_preview.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/layout/task/tasks_preview.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/layout/dashboard/bloc/app_cubit.dart';
import 'package:notes_app/layout/dashboard/bloc/app_states.dart';
import 'package:notes_app/shared/components/bottom_option_bar.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 0.0,
                    title: Text('Notes'),
                    // leading: IconButton(
                    //   icon: AnimatedIcon(
                    //     icon: AnimatedIcons.menu_close,
                    //     progress: cubit.drawerController,
                    //     semanticLabel: 'Show menu',
                    //   ),
                    //   onPressed: () => cubit.openDrawer(),
                    // ),
                    leading: IconButton(
                      icon: Icon(Icons.calendar_view_week),
                      onPressed: () => cubit.openDrawer(),
                    ),
                    automaticallyImplyLeading: true,
                    actions: [
                      // IconButton(
                      //     onPressed: () async{
                      //       scaffoldKey.currentState!.showBottomSheet(
                      //         (context) => Container(
                      //           height: 100,
                      //           color: Colors.white,
                      //         ),
                      //       );
                      //     },
                      //     icon: Icon(Icons.star)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/search.svg',
                            color: greyColor,
                          )),
                      SizedBox(
                        width: 10,
                      )
                    ],
                    pinned: true,
                    snap: true,
                    floating: true,
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
                      labelStyle: TextStyle(fontSize: 15),
                      isScrollable: true,
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
                      data: cubit.allNotesDataList,
                      onLongPress: (data, index) {
                        showOptionBar(context,
                            favFun: () => cubit.addToFavorite(context,
                                isFavorite: cubit.allNotesDataList[index]
                                            ['is_favorite'] ==
                                        0
                                    ? false
                                    : true,
                                noteId: data['id'],
                                tableName: 'notes',
                                isFavoriteItem: cubit.allNotesDataList,
                                index: index),
                            deleteFun: () => cubit.deleteNote(context,
                                id: data['id'],
                                tableName: 'Notes',
                                index: index,
                                listOfData: cubit.allNotesDataList),
                            secretFun: () => cubit.addToSecret(
                                context,
                                data['id'],
                                'notes',
                                cubit.allNotesDataList,
                                index),
                            isFavorite: cubit.allNotesDataList[index]
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
                        body: cubit.allTasksDataList,
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
                        data: cubit.allMemoriesDataList,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => cubit.addFABBtnRoutes(context),
            tooltip: 'Add New',
            child: RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0)
                  .animate(cubit.fABController!),
              child: Icon(
                cubit.tabBarController!.index == 0
                    ? Icons.article_outlined
                    : cubit.tabBarController!.index == 1
                        ? Icons.task_outlined
                        : Icons.event_available_outlined,
                size: 30,
              ),
            ),
          ),
          extendBody: false,
          resizeToAvoidBottomInset: true,
        );
      },
      listener: (context, state) {},
    );
  }
}

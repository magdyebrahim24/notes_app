import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:notes_app/shared/share/share_functions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
            body: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: SliverAppBar(
                        elevation: 0.0,
                        title: Text(
                          'Nota',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        centerTitle: true,
                        leading: IconButton(
                            onPressed: () => cubit.isDrawerCollapsed
                                ? cubit.openDrawer()
                                : null,
                            icon: SvgPicture.asset(
                              'assets/icons/drawer.svg',
                              color: Theme.of(context).primaryColorLight,
                            )),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/search.svg',
                                color: Theme.of(context).primaryColorLight,
                              )),
                          SizedBox(
                            width: 10,
                          )
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
                          indicatorPadding: EdgeInsets.only(
                            top: 15,
                            left: 15,
                            right: 15,
                          ),

                          labelPadding: EdgeInsets.symmetric(horizontal: 25),
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                    controller: cubit.tabBarController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      NotePreview(
                        selectedItemIndex: cubit.selectedItemIndex,
                        data: cubit.allNotesDataList,
                        onLongPress: (data, index) {
                          cubit.toggleFAB(index);
                          showOptionBar(context,isSecret: cubit.allNotesDataList[index]['is_secret'],
                              shareFun: ()=> shareNoteAndMemory(cubit.allNotesDataList[index]['images']??[]  ,cubit.allNotesDataList[index]['title'],cubit.allNotesDataList[index]['body'],'note'),
                              favFun: () => cubit.addToFavorite(context,
                                  isFavorite: cubit.allNotesDataList[index]
                                              ['is_favorite'] ==
                                          0
                                      ? false
                                      : true,
                                  itemId: data['id'],
                                  tableName: 'notes',
                                  itemsList: cubit.allNotesDataList,
                                  index: index,

                              ),
                              deleteFun: () => cubit.deleteFun(context,
                                  recordsList: cubit.allNotesDataList[index]['records'],
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
                                  ['is_favorite'],
                              onCloseFun:  cubit.toggleFAB);
                        },
                        navFun: (data) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNote(
                                  data: data,
                                ),
                              )).then((value) {
                            cubit.getAllNotesData();
                          });
                        },
                        isLoading: cubit.isLoading,
                      ),
                      TasksPreview(
                          selectedItemIndex: cubit.selectedItemIndex,
                          body: cubit.allTasksDataList,
                          onLongPress: (data, index) {
                            cubit.toggleFAB(index);
                            showOptionBar(context,isSecret: cubit.allTasksDataList[index]['is_secret'],
                                shareFun: ()=> shareTask(cubit.allTasksDataList[index]['title'], cubit.allTasksDataList[index]['title'], cubit.allTasksDataList[index]['taskDate'], cubit.allTasksDataList[index]['subTasks'] ?? []),
                                onCloseFun: cubit.toggleFAB,
                                favFun: () => cubit.addToFavorite(context,
                                    isFavorite: cubit.allTasksDataList[index]
                                                ['is_favorite'] ==
                                            0
                                        ? false
                                        : true,
                                    itemId: data['id'],
                                    tableName: 'tasks',
                                    itemsList: cubit.allTasksDataList,
                                    index: index),
                                deleteFun: () => cubit.deleteFun(context,
                                    id: data['id'],
                                    tableName: 'tasks',
                                    index: index,
                                    listOfData: cubit.allTasksDataList),
                                secretFun: () => cubit.addToSecret(
                                    context,
                                    data['id'],
                                    'tasks',
                                    cubit.allTasksDataList,
                                    index),
                                isFavorite: cubit.allTasksDataList[index]
                                    ['is_favorite']);
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
                          data: cubit.allMemoriesDataList,
                          onLongPress: (data, index) {
                            cubit.toggleFAB(index);
                            showOptionBar(context,isSecret: cubit.allMemoriesDataList[index]['is_secret'],
                                shareFun: ()=> shareNoteAndMemory(cubit.allMemoriesDataList[index]['images'] ?? []  ,cubit.allMemoriesDataList[index]['title'],cubit.allMemoriesDataList[index]['body'],'memory',memoryDate:cubit.allMemoriesDataList[index]['memoryDate'] ),
                                onCloseFun: cubit.toggleFAB,
                                favFun: () => cubit.addToFavorite(context,
                                    isFavorite: cubit.allMemoriesDataList[index]
                                                ['is_favorite'] ==
                                            0
                                        ? false
                                        : true,
                                    itemId: data['id'],
                                    tableName: 'memories',
                                    itemsList: cubit.allMemoriesDataList,
                                    index: index),
                                deleteFun: () => cubit.deleteFun(context,
                                    id: data['id'],
                                    tableName: 'memories',
                                    index: index,
                                    listOfData: cubit.allMemoriesDataList),
                                secretFun: () => cubit.addToSecret(
                                    context,
                                    data['id'],
                                    'memories',
                                    cubit.allMemoriesDataList,
                                    index),
                                isFavorite: cubit.allMemoriesDataList[index]
                                    ['is_favorite']);
                          },
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
            floatingActionButton: cubit.showFAB ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                onPressed: () => Future.delayed(Duration(milliseconds: 0),()=>cubit.addFABBtnRoutes(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 5,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 45,
                  color: Colors.black,
                ),
                color: Theme.of(context).colorScheme.secondary,
                height: 90,
                elevation: 0,
                minWidth: 90,
              ),
            ) : SizedBox(),
        );
      },
      listener: (context, state) {},
    );
  }

}

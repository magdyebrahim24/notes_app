
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/layout/secret/secret.dart';
import 'package:notes_app/layout/setting/setting.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/modules/tab_bar_screens/memories.dart';
import 'package:notes_app/modules/tab_bar_screens/notes.dart';
import 'package:notes_app/modules/tab_bar_screens/tasks.dart';
import 'package:notes_app/shared/bloc/cubit/cubit.dart';
import 'package:notes_app/shared/bloc/states/states.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? tabBarController;
  AnimationController? controller;

  final Duration? duration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    tabBarController = TabController(length: 3, vsync: this);
    controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            body: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      elevation: 0.0,
                      title: Text('Notes'),
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
                              color: greyColor,
                            )),
                        _offsetPopup()
                      ],
                      pinned: true,
                      snap: true,
                      floating: true,
                      bottom: TabBar(
                        controller: tabBarController,
                        tabs: [
                          Tab(
                            text: 'Notes',
                          ),
                          Tab(
                            text: 'Tasks'
                          ),
                          Tab(
                              text: 'Memories',
                          ),
                        ],
                        onTap: (x){
                          controller!.forward(from: 0);
                        },


                        labelStyle: TextStyle(fontSize: 15),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                      ),
                    ),

                  ];
                },
                body: TabBarView(
                    controller: tabBarController,
                    children: [
                  NotesScreen(),
                  TaskScreen(),
                  MemoriesScreen(),
                ]),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                tabBarController!.index == 0
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddNote(cubit.database)))
                    : tabBarController!.index == 1
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddTask()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMemory()));
              },
              tooltip: 'Increment',
              child: RotationTransition(
                turns: Tween<double>(begin: 0 , end: 1).animate(controller!),
                child: Icon(
                  tabBarController!.index == 0 ?
                  Icons.note_add_outlined : tabBarController!.index == 1 ?
                  Icons.task_alt_rounded
                  :                     Icons.event_available_outlined,

                  size: 30,
                ),
              ),
            ),

            // extendBody: true,

            // floatingActionButton: FloatingActionButton(onPressed: () {},
            // child: Icon(Icons.add,size: 30,),),
            // bottomNavigationBar: BottomAppBar(
            //   elevation: 5.0,
            //   color: Colors.white,
            //   notchMargin: 15.0,
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   shape: CircularNotchedRectangle(),
            //
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Icon(Icons.expand),
            //         Icon(Icons.expand),
            //         Icon(Icons.expand),
            //         SizedBox(width: MediaQuery.of(context).size.width * .1,)
            //       ],
            //     ),
            //   ),
            //   // child: BottomNavigationBar(
            //   //   type: BottomNavigationBarType.fixed,
            //   //   enableFeedback: true,
            //   //   backgroundColor: Colors.white,
            //   //
            //   //
            //   //   elevation: 5.0,
            //   //   items: [
            //   //     BottomNavigationBarItem(
            //   //       icon: Icon(Icons.business),
            //   //       label: 'Business',
            //   //     ),
            //   //     BottomNavigationBarItem(
            //   //       icon: Icon(Icons.school),
            //   //       label: 'School',
            //   //     ),
            //   //     BottomNavigationBarItem(
            //   //       icon: Icon(Icons.settings),
            //   //       label: 'Settings',
            //   //     ),
            //   //   ],
            //   //   // currentIndex: _selectedIndex,
            //   //   onTap: (value){},
            //   //   showSelectedLabels: false,
            //   //   showUnselectedLabels: false,
            //   //
            //   //
            //   //
            //   // ),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          );
        },
      ),
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
      tooltip: 'More',
      enableFeedback: true,
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Secret()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Setting()));
        }
      },
      // offset: Offset(-10,45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                "Setting",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuItem(
              // padding: EdgeInsets.symmetric(horizontal: 50),

              value: 2,
              child: Text(
                "Secret",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ],
      icon: Icon(
        Icons.more_vert,
        color: greyColor,
      ));
}
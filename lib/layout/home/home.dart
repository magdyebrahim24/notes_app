import 'package:flutter/material.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/note/note_preview.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/layout/task/tasks_preview.dart';
import 'package:notes_app/layout/memories/memories_preview.dart';
import 'package:notes_app/verify/login.dart';
import 'package:notes_app/layout/setting/setting.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  final cubit;

  final database;
  Home(this.cubit, this.database);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0.0,
                title: Text('Notes'),
                leading: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: widget.cubit.drawerController,
                    semanticLabel: 'Show menu',
                  ),
                  onPressed: () => widget.cubit.openDrawer(),
                ),
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
                  SizedBox(
                    width: 10,
                  )
                ],
                pinned: true,
                snap: true,
                floating: true,
                bottom: TabBar(
                  controller: widget.cubit.tabBarController,
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
              controller: widget.cubit.tabBarController,
              physics: BouncingScrollPhysics(),
              children: [
                // GridViewComponents(
                //     widget.cubit.allNotesDataList,
                //     () => widget.cubit.getDataAndRebuild(),
                //     widget.cubit.isLoading),
                NotePreview(data: widget.cubit.allNotesDataList, navFun: (data) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNote(
                          data: data,
                        ),
                      )).then((value) {
                    widget.cubit.getNotesDataWithItsImages();
                  });
                },isLoading: widget.cubit.isLoading,),
                TasksPreview(
                   body:  widget.cubit.allTasksDataList,
                   onTapFun:   (data) {
                       Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => AddTask(
                                         data: data,
                                       ),
                                     )).then((value) {
                         widget.cubit.getAllTasksDataWithItSubTasks();                                 });
                    },
                    // () => widget.cubit.getAllTasksDataWithItSubTasks(),
                 isLoading:    widget.cubit.isLoading),

                MemoriesPreview(
                    data: widget.cubit.allMemoriesDataList,
                    isLoading: widget.cubit.isLoading,
                    onTapFun: (data) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMemory(
                              data: data,
                            ),
                          )).then((value) {
                           widget.cubit.getAllMemoriesDataWithItsImages();
                      });
                    }),

              ]),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.cubit.addFABBtnRoutes(context),
        tooltip: 'Increment',
        child: RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0)
              .animate(widget.cubit.fABController!),
          child: Icon(
            widget.cubit.tabBarController!.index == 0
                ? Icons.article_outlined
                : widget.cubit.tabBarController!.index == 1
                    ? Icons.task_outlined
                    : Icons.event_available_outlined,
            size: 30,
          ),
        ),
      ),

    );
  }

  Widget _offsetPopup(context) => PopupMenuButton<int>(
      tooltip: 'More',
      enableFeedback: true,
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
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


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
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

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
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
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: DropdownButton(
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {});
                    },
                    items: ['Setting', 'Secret']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    icon: Icon(
                      Icons.more_vert,
                      color: greyColor,
                    ),
                  ),
                ),
              ],
              title: Text('Notes'),
              bottom: TabBar(
                controller: controller,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.note_add_outlined,
                    size: 40,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.task_outlined,
                    size: 40,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.event_available_outlined,
                    size: 40,
                  )),
                ],
                isScrollable: true,
              ),
            ),
            body: TabBarView(
              controller: controller,
              children: [
                NotesScreen(),
                TaskScreen(),
                MemoriesScreen(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller!.index == 0 ?
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddNote()))
                : controller!.index == 1 ? Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddTask())) :
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddMemory()))
                ;},
              tooltip: 'Increment',
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}

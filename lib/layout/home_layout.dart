import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/modules/home_nav_screens/memories.dart';
import 'package:notes_app/modules/home_nav_screens/notes.dart';
import 'package:notes_app/modules/home_nav_screens/tasks.dart';
import 'package:notes_app/shared/components/circle_tab_Indicator.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:notes_app/shared/cubit/cubit.dart';
import 'package:notes_app/shared/cubit/states.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/search.svg',
                      color: greyColor,
                    )),
                // IconButton(onPressed: (){}, icon:Icon(Icons.more_vert,color: greyColor,)),
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
              children: [NotesScreen(), TaskScreen(), MemoriesScreen(),],
            ),
            // body: Center(
            //   // Center is a layout widget. It takes a single child and positions it
            //   // in the middle of the parent.
            //   child: Column(
            //
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         'You have pushed the button this many times:',
            //       ),
            //       Text(
            //         cubit.counter.toString(),
            //         style: Theme.of(context).textTheme.headline4,
            //       ),
            //     ],
            //   ),
            // ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => cubit.plusCounter(),
              tooltip: 'Increment',
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
// This trailing comma makes auto-formatting nicer for build methods.
          );
        },
      ),
    );
  }
}

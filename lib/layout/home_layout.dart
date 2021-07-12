import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/cubit/cubit.dart';
import 'package:notes_app/shared/cubit/states.dart';

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context,AppStates state) {  },
        builder: (BuildContext context,AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('test'),
            ),
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    cubit.counter.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:()=> cubit.plusCounter(),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ), //
            bottomNavigationBar: BottomNavigationBar(

type: BottomNavigationBarType.fixed,
              currentIndex: 0,

              items: [
                BottomNavigationBarItem(icon: Icon(Icons.done),label: '.',activeIcon: Icon(Icons.circle)),
                BottomNavigationBarItem(icon: Icon(Icons.done),label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.done),label: ''),
              ],
            ),
          );
        },

      ),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/cubit.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';

class FavoriteScreen extends StatelessWidget {

  static const List<Widget> bodyList = <Widget>[
    Text('1'),Text('2'),Text('3'),
  ];
  int index = 0 ;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> FavoriteCubit()..onBuild(),
      child: BlocConsumer<FavoriteCubit,FavoriteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FavoriteCubit cubit = FavoriteCubit.get(context);

          return  Scaffold(
            appBar: AppBar(),
            body: bodyList[index],
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                clipBehavior: Clip.antiAlias,
                child: BottomNavigationBar(
                  showUnselectedLabels: false,
                  selectedIconTheme: IconThemeData(),
                  currentIndex: cubit.navBarIndex ,
                  onTap:(value)=> cubit.onNavBarIndexChange(value),
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.note_outlined) ,label: 'Notes'),
                    BottomNavigationBarItem(icon: Icon(Icons.task_outlined) , label: 'Tasks'),
                    BottomNavigationBarItem(icon: Icon(Icons.archive),label: 'Memory' ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
   Widget notes(){
    return Column(
      children: [

      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/cubit.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/layout/home/home.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/components/gridview.dart';
import 'package:notes_app/shared/components/note_card.dart';

class FavoriteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> FavoriteCubit()..onBuild(),
      child: BlocConsumer<FavoriteCubit,FavoriteStates>(
        listener: (context, state) {},
        builder: (context, state) {

          FavoriteCubit cubit = FavoriteCubit.get(context);
          List <Widget> bodyList=[
            GridViewComponents(cubit.notes,()=>cubit.getDataAndRebuild(),cubit.isLoading),
    TaskWidget(data: cubit.tasks ,navFun: (data){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask(data: data,),)).then((value) {
    cubit.getDataAndRebuild();
    });
    }),
    TaskWidget(data: cubit.memories ,navFun: (data){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemory(data: data,),)).then((value) {
    cubit.getDataAndRebuild();
    });}),
          ];
          return  Scaffold(
            appBar: AppBar(),
            body: bodyList[cubit.navBarIndex],
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';
import 'bloc/cubit/add_task_cubit.dart';
import 'bloc/states/states.dart';

class AddTask extends StatelessWidget {
  final data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  AddTask({this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddTaskCubit()..onBuild(data),
      child: BlocConsumer<AddTaskCubit, AppTaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AddTaskCubit cubit = AddTaskCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      if(formKey.currentState!.validate())
                        cubit.saveTaskBTNFun(context);
                    },
                    icon: Icon(Icons.done)),
              ],
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultFormField(
                        controller: cubit.titleController,
                        maxLines: null,
                        minLines: null,
                        fillColor: Theme.of(context).primaryColor,
                        hintText: 'Title',
                        validator: (value){
                          if(value.toString().isEmpty)
                            return 'task title can\'t be empty';
                        },
                        hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 28,
                            fontWeight: FontWeight.normal),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Task Date',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    color: Colors.white24,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      cubit.datePicker(context);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            cubit.dateController ?? 'Add',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Task Time',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    color: Colors.white24,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      cubit.timePicker(context);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            cubit.timeController ?? 'Add',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.subTasksList.length,
                          itemBuilder: (context, index) => Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    onChanged: (value) {
                                      cubit.changeCheckbox(index);
                                    },
                                    value: cubit.subTasksList[index]
                                            ['isDone'] ??
                                        false,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => blueColor),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: cubit.subTasksList[index]
                                            ['body'],
                                        style: TextStyle(
                                          decoration: cubit.subTasksList[index]
                                                  ['isDone']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: cubit.subTasksList[index]
                                                  ['isDone']
                                              ? Colors.white60
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'write sub task',
                                          disabledBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: greyColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal),
                                          fillColor:
                                              Theme.of(context).primaryColor,
                                          border: InputBorder.none,
                                        ),
                                        validator: (text) {
                                          if (text.toString().isEmpty)
                                            return 'you must type sub task first';
                                        }),
                                  ),
                                  IconButton(
                                      onPressed: () =>
                                          cubit.deleteSubTaskFromDataBase(
                                              index, context),
                                      icon: Icon(Icons.clear,
                                          color: Colors.white60, size: 19)),
                                ],
                              )),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.newTasksList.length,
                          itemBuilder: (context, index) => Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    onChanged: (value) {
                                      cubit.changeNewSubTAskCheckbox(index);
                                    },
                                    value: cubit.newTasksList[index]['isDone'],
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => blueColor),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: cubit.newTasksList[index]
                                            ['body'],
                                        style: TextStyle(
                                          decoration: cubit.newTasksList[index]
                                                  ['isDone']
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: cubit.newTasksList[index]
                                                  ['isDone']
                                              ? Colors.white60
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'write sub task',
                                          disabledBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: greyColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal),
                                          fillColor:
                                              Theme.of(context).primaryColor,
                                          border: InputBorder.none,
                                        ),
                                        validator: (text) {
                                          if (text.toString().isEmpty)
                                            return 'you must type sub task first';
                                        }),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        cubit.deleteUnSavedSubTask(index);
                                      },
                                      icon: Icon(Icons.clear,
                                          color: Colors.white60, size: 19)),
                                ],
                              )),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate())
                            cubit.addNewTask();
                        },
                        style: ButtonStyle(),
                        child: Text(
                          '+  Add sub task',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: cubit.taskID != null
                ? BottomIconBar(
                    deleteFun: () => cubit.deleteTask(context),
                    addToFavoriteFun: () => cubit.addToFavorite(),
                    isFavorite: cubit.isFavorite,
                addToSecretFun: ()=> cubit.addToSecret(),
                  )
                : SizedBox(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            resizeToAvoidBottomInset: true,
          );
        },
      ),
    );
  }
}

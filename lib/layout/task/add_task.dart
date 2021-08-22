import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
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
                      if (formKey.currentState!.validate())
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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline4!.color,
                          fontSize: 28,
                        ),
                        focusNode: cubit.titleFocus,
                        controller: cubit.titleController,
                        maxLines: null,
                        minLines: null,
                        fillColor: Theme.of(context).primaryColor,
                        hintText: 'Title',
                        validator: (value) {
                          if (value.toString().isEmpty)
                            return 'task title can\'t be empty';
                        },
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
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
                            color: Theme.of(context).dividerColor),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'Task Date',
                                    style: TextStyle(
                                        fontSize: 18, color: Theme.of(context).textTheme.headline4!.color),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    color: Theme.of(context).dividerColor,
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
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          color: Theme.of(context).textTheme.headline6!.color,
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
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'Task Time',
                                    style: TextStyle(
                                        fontSize: 18, color: Theme.of(context).textTheme.headline4!.color),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    color: Theme.of(context).dividerColor,
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
                                              style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          color: Theme.of(context).textTheme.headline6!.color,
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
                                children: [
                                  Checkbox(

                                    onChanged: (value) {
                                      cubit.changeCheckbox(index);
                                    },
                                    value: cubit.subTasksList[index]
                                            ['isDone'] ??
                                        false,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: cubit.subTasksList[index]
                                            ['body'],
                                        style: cubit.subTasksList[index]
                                        ['isDone']?
                                        Theme.of(context).textTheme.bodyText1:Theme.of(context).textTheme.bodyText2,
                                        decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintText: 'write sub task',
                                          disabledBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Theme.of(context).hintColor,
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
                                          color: Theme.of(context).textTheme.bodyText1!.color, size: 19)),
                                ],
                              )),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.newTasksList.length,
                          itemBuilder: (context, index) => Row(
                                children: [
                                  Checkbox(
                                    onChanged: (value) {
                                      cubit.changeNewSubTAskCheckbox(index);
                                    },
                                    value: cubit.newTasksList[index]['isDone'],
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: cubit.newTasksList[index]
                                            ['body'],
                                        style: cubit.newTasksList[index]
                                        ['isDone']?Theme.of(context).textTheme.bodyText1:Theme.of(context).textTheme.bodyText2,
                                        decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintText: 'write sub task',
                                          disabledBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Theme.of(context).hintColor,
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
                                          color: Theme.of(context).textTheme.bodyText1!.color, size: 19)),
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
                          style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: cubit.taskID != null
                ? BottomIconBar(
                    deleteFun: () => cubit.deleteTask(context),
                    addToFavoriteFun: () => cubit.addToFavorite(),
                    isFavorite: cubit.isFavorite,
                    addToSecretFun: () => cubit.addToSecret(context),
                  )
                : SizedBox(),
          );
        },
      ),
    );
  }
}

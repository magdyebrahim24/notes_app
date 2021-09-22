
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'bloc/add_task_cubit.dart';
import 'bloc/add_task_states.dart';

class AddTask extends StatelessWidget {
  final data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddTask({this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddTaskCubit()..onBuild(data),
      child: BlocConsumer<AddTaskCubit, AppTaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AddTaskCubit cubit = AddTaskCubit.get(context);
          return WillPopScope(
            onWillPop: ()=> cubit.onCloseSave(context),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(onPressed: ()=>Navigator.pop(context),icon: Icon(Icons.arrow_back_ios),iconSize: 20,),
                actions: [
                  IconButton(
                      onPressed: ()=> cubit.saveTaskBTNFun(context) ,
                      icon: Icon(Icons.done)),
                ],
              ),
              body: Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(37, 17, 37, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title',style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 28),),
                        Container(
                          margin: EdgeInsets.only(bottom: 20,top: 15),
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 4),
                          decoration: BoxDecoration(color: Theme.of(context).cardTheme.color,borderRadius: BorderRadius.circular(10)),
                          child: DefaultFormField(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline4!.color,
                              fontSize: 16,
                            ),
                            focusNode: cubit.titleFocus,
                            controller: cubit.titleController,
                            maxLines: 3,
                            minLines: 2,
                            hintText: 'Your title...',
                            validator: (value) {
                              if (value.toString().isEmpty)
                                return 'task title can\'t be empty';
                            },
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: dateTimeWidget(context,label: 'Date',errorText:cubit.showTaskDateValidateText ? 'date required' : null,fun: ()=> cubit.datePicker(context) ,height: 48.0,text: cubit.taskDate ?? 'MM DD,YYYY' ,iconPath: 'assets/icons/date.svg')),
                            SizedBox(width: MediaQuery.of(context).size.width * .1,),
                            Expanded(child: dateTimeWidget(context,label: 'Time',errorText:cubit.showTaskTimeValidateText ? 'time required' : null,fun: ()=> cubit.timePicker(context) ,height: 48.0,text: cubit.taskTime ?? '00:00 AM' ,iconPath: 'assets/icons/date.svg')),
                          ],
                        ),
                        SizedBox(height: 30,),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cubit.subTasksList.length,padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Checkbox(
                                        onChanged: (value) {
                                          cubit.changeCheckbox(index);
                                        },
                                        value: cubit.subTasksList[index]
                                                ['isDone'] ??
                                            false,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                          controller: cubit.subTasksList[index]['body'],
                                          style: cubit.subTasksList[index]['isDone']  ?
                                          Theme.of(context).textTheme.bodyText1!.copyWith(decoration: TextDecoration.lineThrough) : Theme.of(context).textTheme.bodyText1,
                                          decoration: InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            hintText: 'Your text...',
                                            disabledBorder: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Theme.of(context).hintColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                            border: InputBorder.none,
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (text) {
                                            if (text.toString().isEmpty)
                                              return 'can\'t be empty';
                                          }),
                                    ),
                                    IconButton(
                                        onPressed: () =>
                                            cubit.deleteOneSubTaskFrom(
                                                index, context),
                                        icon: Icon(Icons.clear,
                                            color: Theme.of(context).textTheme.bodyText1!.color, size: 19)),
                                  ],
                                )),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,padding: EdgeInsets.zero,
                            itemCount: cubit.newTasksList.length,
                            itemBuilder: (context, index) => Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Checkbox(
                                        onChanged: (value) {
                                          cubit.changeNewSubTaskCheckbox(index);
                                        },
                                        value: cubit.newTasksList[index]['isDone'],
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                          controller: cubit.newTasksList[index]
                                              ['body'],
                                          style: cubit.newTasksList[index]['isDone'] ?
                                          Theme.of(context).textTheme.bodyText1!.copyWith(decoration: TextDecoration.lineThrough) : Theme.of(context).textTheme.bodyText1,
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
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (text) {
                                            if (text.toString().isEmpty)
                                              return 'can\'t be empty';
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
                        SizedBox(height: 10,),
                        MaterialButton(
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate())
                              cubit.addNewSubTask();
                          },
                          padding: EdgeInsets.zero,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: [
                              Icon(Icons.add,size: 28,color: Theme.of(context).textTheme.headline6!.color,),
                              SizedBox(width: 15,),
                              Text(
                                'Add SubTask',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: cubit.taskID != null
                  ? AddTaskBottomIconBar(
                      deleteFun: () => cubit.deleteTask(context),
                      addToFavoriteFun: () => cubit.addToFavorite(context),
                      isFavorite: cubit.isFavorite,
                      addToSecretFun: () => cubit.addTaskToSecret(context),
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}

Widget dateTimeWidget(context,{label,text,fun,iconPath,height,textSize = 12.0 , errorText}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style: TextStyle(color: Theme.of(context).hintColor,fontSize: 20,fontWeight: FontWeight.w400),),
      SizedBox(height: 10,),
      MaterialButton(
        height: height,
        minWidth: 118,
        padding: EdgeInsets.symmetric(
            vertical: 15, horizontal: 15),
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8)),
        onPressed: fun,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                      text,
                      style: TextStyle(color: Theme.of(context).hintColor,fontSize: textSize,fontWeight: FontWeight.w400),)
                ),
                SvgPicture.asset(iconPath,color: Theme.of(context).hintColor,),

              ],
            ),
            errorText != null ? Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(errorText.toString(),style: Theme.of(context).inputDecorationTheme.errorStyle!.copyWith(fontSize: 12),),
            ) : SizedBox(),
          ],
        ),
      ),
    ],
  );
}
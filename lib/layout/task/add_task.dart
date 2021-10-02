
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:notes_app/shared/share/share_functions.dart';
import 'bloc/add_task_cubit.dart';
import 'bloc/add_task_states.dart';

class AddTask extends StatelessWidget {
  final data;


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
              appBar: AppBar(
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
                        Text(Languages.of(context)!.addTask['title'],style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 28),),
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
                            hintText: Languages.of(context)!.addTask['titleBody'].toString(),
                            validator: (value) {
                              if (value.toString().isEmpty)
                                return Languages.of(context)!.addTask['titleError'].toString();
                            },
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: dateTimeWidget(context,label: Languages.of(context)!.addTask['date'],errorText:cubit.showTaskDateValidateText ? Languages.of(context)!.addTask['dateError'] : null,fun: ()=> cubit.datePicker(context) ,height: 48.0,text: cubit.taskDate ?? 'MM DD,YYYY' ,iconPath: 'assets/icons/date.svg')),
                            SizedBox(width: MediaQuery.of(context).size.width * .1,),
                            Expanded(child: dateTimeWidget(context,label: Languages.of(context)!.addTask['time'],errorText:cubit.showTaskTimeValidateText ? Languages.of(context)!.addTask['timeError'] : null,fun: ()=> cubit.timePicker(context) ,height: 48.0,text: cubit.taskTime ?? '00:00 AM' ,iconPath: 'assets/icons/time.svg')),
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
                                            hintText: Languages.of(context)!.addTask['bodySubTask'].toString(),
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
                                              return Languages.of(context)!.addTask['bodySubTaskError'].toString();
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
                                            hintText: Languages.of(context)!.addTask['bodySubTask'],
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
                                              return Languages.of(context)!.addTask['bodySubTaskError'];
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
                                Languages.of(context)!.addTask['addSubTask'],
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
                isSecret: cubit.isSecret == 0 ? false : true,
                shareFun: ()=> shareTask(cubit.titleController.text, cubit.taskDate, cubit.taskTime, cubit.subTasksList),
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
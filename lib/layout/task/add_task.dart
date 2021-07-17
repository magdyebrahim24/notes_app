import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';
import 'bloc/cubit/add_task_cubit.dart';
import 'bloc/states/states.dart';

class AddTask extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (BuildContext context)=> AddTaskCubit(),
      child: BlocConsumer<AddTaskCubit , AppTaskStates>(
        listener: (context , state){},
        builder: (context,state){
          AddTaskCubit cubit = AddTaskCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultFormField(
                      controller: _titleController,
                      maxLines: null,
                      minLines: null,
                      fillColor: Theme.of(context).primaryColor,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 28,
                          fontWeight: FontWeight.normal),
                    ),
                    // TextFormField(
                    //   controller: _titleController,
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 28,
                    //       fontWeight: FontWeight.w800
                    //   ),
                    //   maxLines: null,
                    //   minLines: null,
                    //   decoration: InputDecoration(
                    //     hintText: 'Title',
                    //     disabledBorder: InputBorder.none,
                    //     hintStyle: TextStyle(color: greyColor, fontSize: 28,fontWeight: FontWeight.normal),
                    //     fillColor: Theme.of(context).primaryColor,
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10,),
                      height: 2,width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white24
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.newTask.length,
                        itemBuilder: (context,index)=>Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              onChanged: (value){
                                cubit.changeCheckbox(index);
                              },
                              value: cubit.newTask[index]['isChecked'],
                              fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: cubit.newTask[index]['task'],
                                style: TextStyle(
                                  decoration: cubit.newTask[index]['isChecked'] ?TextDecoration.lineThrough:null,
                                    color: cubit.newTask[index]['isChecked'] ?Colors.white60:Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Add Task',
                                  disabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(color: greyColor, fontSize: 20,fontWeight: FontWeight.normal),
                                  fillColor: Theme.of(context).primaryColor,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: (){cubit.deleteTask(index);},
                                icon: Icon(Icons.clear,color: Colors.white60,)),
                          ],
                        )),

                    TextButton(
                        onPressed: (){cubit.addNewTask();},
                       style: ButtonStyle(
                       ),
                        child: Text('+  Add new task',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 18
                          ),),
                    )
                  ],
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}

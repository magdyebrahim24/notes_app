import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/cubit.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:notes_app/shared/components/bottom_navigation_bar.dart';
import 'package:notes_app/shared/components/image_list.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';

class AddMemory extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AddMemoryCubit(),
        child: BlocConsumer<AddMemoryCubit,AppMemoryStates>(
    listener: (context,state){},
        builder: (context,state){
          AddMemoryCubit cubit = AddMemoryCubit.get(context);
      return Scaffold(
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
                //   ),),
                Container(
                  margin: EdgeInsets.only(bottom: 10,),
                  height: 2,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white24
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  width: double.infinity,

                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Text('Memory Date',style: TextStyle(fontSize: 18,color: Colors.white),),
                      Spacer(),
                      MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        color: Colors.white24,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: (){
                        cubit.datePicker(context);},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(cubit.dateController ?? 'Add',style: TextStyle(fontSize: 16,color: Colors.white),),
                            ),
                            Icon(Icons.expand_more,color: Colors.white,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ),
                SizedBox(height: 15,),
                ImageList(imageList: cubit.addedImages),
                // ListView.builder(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: cubit.newTask.length,
                //     itemBuilder: (context,index)=>Row(
                //       children: [
                //         Checkbox(
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                //           onChanged: (value){
                //             cubit.changeCheckbox(index);
                //           },
                //           value: cubit.newTask[index]['isChecked'],
                //           fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
                //         ),
                //         Expanded(
                //           child: TextFormField(
                //             controller: cubit.newTask[index]['task'],
                //             style: TextStyle(
                //               decoration: cubit.newTask[index]['isChecked'] ?TextDecoration.lineThrough:null,
                //               color: cubit.newTask[index]['isChecked'] ?Colors.white60:Colors.white,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w800,
                //             ),
                //             decoration: InputDecoration(
                //               hintText: 'Add Task',
                //               disabledBorder: InputBorder.none,
                //               hintStyle: TextStyle(color: greyColor, fontSize: 20,fontWeight: FontWeight.normal),
                //               fillColor: Theme.of(context).primaryColor,
                //               border: InputBorder.none,
                //             ),
                //           ),
                //         ),
                //         IconButton(
                //             onPressed: (){cubit.deleteTask(index);},
                //             icon: Icon(Icons.clear,color: Colors.white60,)),
                //       ],
                //     )),
                //
                // TextButton(
                //   onPressed: (){cubit.addNewTask();},
                //   style: ButtonStyle(
                //   ),
                //   child: Text('+  Add new task',
                //     style: TextStyle(
                //         color: Colors.white60,
                //         fontSize: 18
                //     ),),
                // )
              ],
            ),
          ),
        ),
          bottomNavigationBar: MyBottomNavigationBar(
            onPressed: () => cubit.pickImage(ImageSource.gallery),
          )
      );
        },),

    );
  }
}

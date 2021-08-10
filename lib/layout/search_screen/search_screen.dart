import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/search_screen/bloc/search_cubit.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/constants.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..onBuild(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(60, 60),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: cubit.searchController,
                      decoration: InputDecoration(
                        focusColor: greyColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white60)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        fillColor: Colors.grey.withOpacity(.1),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey.withOpacity(.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: TextStyle(
                          color: greyColor,
                        ),
                        hintText: 'Search ...',
                        suffixStyle: TextStyle(color: greyColor),
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {
                        cubit.search(cubit.searchController.text);
                      },
                      onChanged: (value) {
                        cubit.search(value);
                      },
                      autofocus: true,
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                  itemCount: cubit.searchResult.length,
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  itemBuilder: (context, index) => Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        color: Color(0xff2e2e3e),
                        elevation: 5,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        semanticContainer: true,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (cubit.searchResult[index]['type'] == 'note') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNote(
                                      data: cubit.searchResult[index],
                                    ),
                                  ));
                            } else if (cubit.searchResult[index]['type'] ==
                                'task') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTask(
                                        data: cubit.searchResult[index]),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMemory(
                                        data: cubit.searchResult[index]),
                                  ));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cubit.searchResult[index]['title'] ??
                                            'Title',
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      // Container(
                                      //   color: Colors.white24,
                                      //   height: .5,
                                      //   margin: EdgeInsets.symmetric(vertical: 10),
                                      // ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${cubit.searchResult[index]['createdDate']} , ${cubit.searchResult[index]['createdTime']}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  '${cubit.searchResult[index]['type']}',
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )));
        },
      ),
    );
  }
}
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: InkWell(
// onTap: () {
// if (cubit.searchResult[index]['type'] == 'note') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => AddNote(
// data: cubit.searchResult[index],
// ),
// ));
// } else if (cubit.searchResult[index]['type'] ==
// 'task') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// AddTask(data: cubit.searchResult[index]),
// ));
// } else {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => AddMemory(
// data: cubit.searchResult[index]),
// ));
// }
// },
// child: Container(
// padding: EdgeInsets.all(15),
// color: Colors.white,
// child: Text(cubit.searchResult[index]['title'])),
// ),
// ))

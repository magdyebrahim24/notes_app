
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/search_screen/bloc/search_cubit.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

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
                preferredSize: Size(50, 50),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: cubit.searchController,
                    decoration: InputDecoration(
                      prefixIconConstraints: BoxConstraints.tightFor(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 10, 0),
                        child: SvgPicture.asset(
                          'assets/icons/search_icon.svg',
                          fit: BoxFit.scaleDown,
                          height: 22,
                          width: 22,
                          color: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle!
                              .color,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                      hintText: 'Search',
                    ),
                    style: Theme.of(context).textTheme.subtitle1,
                    cursorColor: Theme.of(context).accentColor,
                    cursorWidth: 3,
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
            body: cubit.searchResult.length != 0
                ? ListView.builder(
                    itemCount: cubit.searchResult.length,
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    itemBuilder: (context, index) => Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                          elevation: 5,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          semanticContainer: true,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(fontSize: 22),
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
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
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
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
                        ))
                : image(cubit.searchController.text , cubit.searchResult.length == 0 && cubit.searchController.text != ''  ? true : false ,context),
          );
        },
      ),
    );
  }

  Widget image(text , showNoResultTxt,context) {
    return Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(25.0),
            child: Column(
                children: [
                  // shadedImage('assets/images/search.png'),
                  Image.asset('assets/images/search.png',fit: BoxFit.fitHeight,),
                  SizedBox(height: 20,),
                  showNoResultTxt ? Text('No Result For $text',style: TextStyle(fontSize: 20),softWrap: true,textAlign: TextAlign.center,) : SizedBox(),
                ],
              ),
          ),
        ));
  }
}

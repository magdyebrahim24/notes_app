import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/search_screen/bloc/search_cubit.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:notes_app/layout/search_screen/search_cards.dart';

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
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    cursorColor: Theme.of(context).colorScheme.secondary,
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
                    itemBuilder: (context, index) =>
                        cubit.searchResult[index]['type'] == 'note'
                            ? NoteSearchCard(
                                data: cubit.searchResult[index],
                              )
                            : cubit.searchResult[index]['type'] == 'task'
                                ? TaskSearchCard(
                                    data: cubit.searchResult[index],
                                  )
                                : MemorySearchCard(
                                    data: cubit.searchResult[index],
                                  ))
                : image(
                    cubit.searchController.text,
                    cubit.searchResult.length == 0 &&
                            cubit.searchController.text != ''
                        ? true
                        : false,
                    context),
          );
        },
      ),
    );
  }

  Widget image(text, showNoResultTxt, context) {
    return Center(
        child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // shadedImage('assets/images/search.png'),
            Image.asset(
              'assets/images/search.png',
              fit: BoxFit.scaleDown,
              scale: 1.15,
            ),
            SizedBox(
              height: 20,
            ),
            showNoResultTxt
                ? Text(
                    'No Result For $text',
                    style: TextStyle(fontSize: 20),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  )
                : SizedBox(),
          ],
        ),
      ),
    ));
  }
}

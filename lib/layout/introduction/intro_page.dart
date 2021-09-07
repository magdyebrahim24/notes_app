import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/introduction/bloc/intro_cubit.dart';
import 'package:notes_app/layout/introduction/bloc/intro_states.dart';

class IntroPage extends StatelessWidget {

 final List introImages = [
    'assets/intro/notes.png',
    'assets/intro/tasks.png',
    'assets/intro/memories.png',
  ];
  final List text = [
    {
      'title': 'Notes',
      'body':
          'You can write whatever you want, put a picture or an audio recording to hear it whenever you want !'
    },
    {
      'title': 'Tasks',
      'body':
          'Add your Missions as a tasks to motivate you to complete them and organize your tasks'
    },
    {
      'title': 'Memories',
      'body':
          'Put all your memories here to always remember them whenever you want!'
    },
  ];


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocProvider(
      create: (context) => IntroCubit(),
      child: BlocConsumer<IntroCubit,IntroStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = IntroCubit.get(context);
          return  Scaffold(
              body: PageView.builder(
                physics: PageScrollPhysics(),
                controller: cubit.pageController,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              introImages[index].toString(),
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Text(text[index]['title'],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headline4),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal: MediaQuery.of(context).size.width * .2),
                              child: Text(
                                text[index]['body'],
                                style:
                                theme.textTheme.bodyText2!.copyWith(height: 1.4),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: cubit.onPageChanged,
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    inductor(cubit.currentPage,context),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: ()=> cubit.nextBTN(context),
                      height: 60,
                      minWidth: MediaQuery.of(context).size.width * .8,
                      child: Text(
                       cubit.currentPage != 2 ? 'NEXT' : 'GET STARTED',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: theme.accentColor,
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget inductor(currentPage,context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: currentPage == i ? 30 : 10,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: currentPage == i
                  ? Theme.of(context).accentColor
                  : Color(0xffCCCCCC),
            ),
          ),
      ],
    );
  }
}

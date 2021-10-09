import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/introduction/bloc/intro_cubit.dart';
import 'package:notes_app/layout/introduction/bloc/intro_states.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/shared/bloc_observer.dart';
import 'package:notes_app/shared/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MaterialApp(home: Test()));
}

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test>  with TickerProviderStateMixin{
  final List labels = ['Notes', 'Tasks', 'Memories'];

  final List body = ['111111111', '2222222222222', '3333333333'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocProvider(
      create: (context) => IntroCubit(),
      child: BlocConsumer<IntroCubit, IntroStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = IntroCubit.get(context);
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SliverAppBar(
                      elevation: 0.0,
                      title: Text(
                        'Nota',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: (){},
                          icon: SvgPicture.asset(
                            'assets/icons/drawer.svg',
                            color: Theme.of(context).primaryColorLight,
                          )),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/search.svg',
                              color: Theme.of(context).primaryColorLight,
                            )),
                        SizedBox(
                          width: 10,
                        )
                      ],
                      pinned: true,
                      snap: true,
                      floating: true,
                      expandedHeight: 120,
                      bottom: PreferredSize(
                        preferredSize: Size(46,46),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            labelBTN(
                                text: labels[0],
                                currentPage: cubit.currentPage.toInt(),
                                fun: () => cubit.changePage(0),
                                index: 0),
                            labelBTN(
                                text: labels[1],
                                currentPage: cubit.currentPage.toInt(),
                                fun: () => cubit.changePage(1),
                                index: 1),
                            labelBTN(
                                text: labels[2],
                                currentPage: cubit.currentPage.toInt(),
                                fun: () => cubit.changePage(2),
                                index: 2),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Directionality(
                  //   textDirection: TextDirection.ltr,
                  //   child: SliverAppBar(
                  //     elevation: 0.0,
                  //     title: Text(
                  //       'Nota',
                  //       style: Theme.of(context).textTheme.headline5,
                  //     ),
                  //     centerTitle: true,
                  //     leading: IconButton(
                  //         onPressed: () {},
                  //         icon: SvgPicture.asset(
                  //           'assets/icons/drawer.svg',
                  //           color: Theme.of(context).primaryColorLight,
                  //         )),
                  //     actions: [
                  //       IconButton(
                  //           onPressed: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => SearchScreen()));
                  //           },
                  //           icon: SvgPicture.asset(
                  //             'assets/icons/search.svg',
                  //             color: Theme.of(context).primaryColorLight,
                  //           )),
                  //       SizedBox(
                  //         width: 10,
                  //       )
                  //     ],
                  //
                  //     // pinned: true,
                  //     snap: true,
                  //     floating: true,
                  //   ),
                  // ),
                  // SliverAppBar(
                  //   pinned: true,
                  //   snap: true,
                  //   floating: true,
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       labelBTN(
                  //           text: labels[0],
                  //           currentPage: cubit.currentPage.toInt(),
                  //           fun: () => cubit.changePage(0),
                  //           index: 0),
                  //       labelBTN(
                  //           text: labels[1],
                  //           currentPage: cubit.currentPage.toInt(),
                  //           fun: () => cubit.changePage(1),
                  //           index: 1),
                  //       labelBTN(
                  //           text: labels[2],
                  //           currentPage: cubit.currentPage.toInt(),
                  //           fun: () => cubit.changePage(2),
                  //           index: 2),
                  //     ],
                  //   ),
                  // ),
                ];
              },
              body: PageView.builder(
                // physics: PageScrollPhysics(),
                controller: cubit.pageController,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  // return CustomScrollView(slivers: <Widget>[
                  //   Directionality(textDirection: TextDirection.ltr,
                  //     child: SliverAppBar(
                  //       elevation: 0.0,
                  //       title: Text(
                  //         'Nota',
                  //         style: Theme.of(context).textTheme.headline5,
                  //       ),
                  //       centerTitle: true,
                  //       leading: IconButton(
                  //           onPressed: () {},
                  //           icon: SvgPicture.asset(
                  //             'assets/icons/drawer.svg',
                  //             color: Theme.of(context).primaryColorLight,
                  //           )),
                  //       actions: [
                  //         IconButton(
                  //             onPressed: () {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => SearchScreen()));
                  //             },
                  //             icon: SvgPicture.asset(
                  //               'assets/icons/search.svg',
                  //               color: Theme.of(context).primaryColorLight,
                  //             )),
                  //         SizedBox(
                  //           width: 10,
                  //         )
                  //       ],
                  //       pinned: true,
                  //       snap: true,
                  //       floating: true,
                  //     ),
                  //   ),
                  //   SliverAppBar(title:Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //
                  //       labelBTN(text: labels[0],currentPage: cubit.currentPage.toInt(),fun: () => cubit.changePage(0),index: 0),
                  //       labelBTN(text: labels[1],currentPage: cubit.currentPage.toInt(),fun: () => cubit.changePage(1),index: 1),
                  //       labelBTN(text: labels[2],currentPage: cubit.currentPage.toInt(),fun: () => cubit.changePage(2),index: 2),
                  //
                  //     ],
                  //   ),),
                  //   SliverToBoxAdapter(
                  //     child: Text(body[cubit.currentPage.toInt()]),
                  //   ),
                  //   // SliverPersistentHeader(delegate:SliverToBoxAdapter(child: Row(),), ),
                  // ]);
                  return SizedBox(
                    height: 200,
                    width: 300,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text(body[cubit.currentPage.toInt()])]),
                  );
                },
                onPageChanged: cubit.onPageChanged,
              ),
            ),

          );
        },
      ),
    );
  }

  Widget inductor(currentPage, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        labelBTN(
            text: labels[0],
            currentPage: currentPage.toInt(),
            fun: () {},
            index: 0),
        labelBTN(
            text: labels[1],
            currentPage: currentPage.toInt(),
            fun: () {},
            index: 1),
        labelBTN(
            text: labels[2],
            currentPage: currentPage.toInt(),
            fun: () {},
            index: 2),
        // Container(
        //   width: currentPage == i ? 30 : 10,
        //   height: 10,
        //   margin: EdgeInsets.symmetric(horizontal: 4),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     color: currentPage == i
        //         ? Theme.of(context).colorScheme.secondary
        //         : Color(0xffCCCCCC),
        //   ),
        // ),
      ],
    );
  }

  Widget labelBTN(
      {required text, required index, required currentPage, required fun}) {
    return Column(
      children: [
        MaterialButton(
          padding: EdgeInsets.zero,
          height: 10,
          onPressed: fun,
          child: Text(text),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        Container(
          width: currentPage == index ? 30 : 10,
          height: 4,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color(0xffCCCCCC),
          ),
        ),
      ],
    );
  }

}

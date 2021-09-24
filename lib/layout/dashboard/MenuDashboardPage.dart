import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/favorite/favorite.dart';
import 'package:notes_app/layout/home/home.dart';
import 'package:notes_app/layout/verify/create_pass.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/layout/setting/setting.dart';
import 'package:notes_app/layout/dashboard/bloc/app_cubit.dart';
import 'package:notes_app/layout/dashboard/bloc/app_states.dart';


class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with TickerProviderStateMixin {
  double? screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..onBuildPage(this),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (BuildContext context, AppStates state) {},
            builder: (BuildContext context, AppStates state) {
              AppCubit cubit = AppCubit.get(context);
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Stack(
                  children: [
                    menu(context,
                        rebuildFunction: () => cubit.getDataAndRebuild(),
                        menuScaleAnimation: cubit.drawerMenuScaleAnimation,
                        slideAnimation: cubit.drawerSlideAnimation,
                        tabBarIndex: cubit.tabBarController!.index,
                        closeDrawerFun: () => cubit.openDrawer()),
                    dashboard(context, cubit: cubit),
                  ],
                ),
              );
            }));
  }

  Widget menu(context,
      {slideAnimation,
      menuScaleAnimation,
      rebuildFunction,
      tabBarIndex,
      closeDrawerFun}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: menuScaleAnimation,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // icon for close
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          .38 * screenWidth!, .2 * screenHeight!, 0, 40),
                      child: IconButton(
                        onPressed: closeDrawerFun,
                        icon: Icon(Icons.close),
                        iconSize: 26,
                        color: Theme.of(context).textTheme.headline3!.color,
                        splashColor: Theme.of(context)
                            .textTheme
                            .headline3!
                            .color!
                            .withOpacity(.33),
                        hoverColor: Theme.of(context)
                            .textTheme
                            .headline3!
                            .color!
                            .withOpacity(.33),
                      ),
                    ),
                    // app name
                    Text(
                      'Nota',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).textTheme.headline3!.color,
                      endIndent: .5 * screenWidth!,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 0.45 * screenWidth!,
                      height: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Theme.of(context).backgroundColor),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/note.svg',
                            height: 23,
                            width: 23,
                            fit: BoxFit.scaleDown,
                            color: Theme.of(context).textTheme.headline3!.color,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                                tabBarIndex == 0
                                    ? 'Notes'
                                    : tabBarIndex == 1
                                        ? 'Tasks'
                                        : 'Memories',
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                style: Theme.of(context).textTheme.headline3),
                          ),
                        ],
                      ),
                    ),
                    _drawerItem(
                        text: 'Favorite',
                        leadingPath: 'assets/icons/star.svg',
                        fun: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(),
                                )).then((value) {
                              rebuildFunction();
                            })),
                    _drawerItem(
                        text: 'Secret',
                        leadingPath: 'assets/icons/unlock.svg',
                        fun: () {
                          String? pass =
                              CacheHelper.getString(key: 'secret_password');
                          if (pass == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePass()));
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Login()));
                          }
                        }),
                    _drawerItem(
                        text: 'Setting',
                        leadingPath: 'assets/icons/setting.svg',
                        fun: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Setting()))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({text, leadingPath, fun}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: 0.46 * screenWidth!,
      child: ListTile(
        title: Text(text, style: Theme.of(context).textTheme.headline3),
        leading: SvgPicture.asset(
          leadingPath,
          height: 23,
          width: 23,
          fit: BoxFit.contain,
          color: Theme.of(context).textTheme.headline3!.color,
        ),
        minLeadingWidth: 25,
        onTap: fun,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        focusColor: Theme.of(context).textTheme.headline3!.color,
        dense: true,
        horizontalTitleGap: 10,
        selectedTileColor: Theme.of(context).textTheme.headline3!.color,
        hoverColor: Theme.of(context).textTheme.headline3!.color,
      ),
    );
  }

  Widget dashboard(context, {cubit}) {
    return AnimatedPositioned(
      duration: cubit.drawerDuration,
      top: cubit.isDrawerCollapsed ? 0 : 0.05 * screenHeight!,
      bottom: cubit.isDrawerCollapsed ? 0 : 0.05 * screenHeight!,
      left: cubit.isDrawerCollapsed ? 0 : 0.55 * screenWidth!,
      right: cubit.isDrawerCollapsed ? 0 : -0.3 * screenWidth!,
      child: ScaleTransition(
        scale: cubit.drawerScaleAnimation!,
        child: Material(
          animationDuration: cubit.drawerDuration!,
          borderRadius: cubit.isDrawerCollapsed
              ? null
              : BorderRadius.all(Radius.circular(25)),
          elevation: 8,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Material(
              shape: cubit.isDrawerCollapsed
                  ? null
                  : Border(top: BorderSide(width: 16,color: Theme.of(context).colorScheme.secondary.withOpacity(.8))),
              child: Stack(
                children: [
                  Home(),
                  GestureDetector(
                    onTap: cubit.isDrawerCollapsed ? null : cubit.openDrawer,
                    onHorizontalDragUpdate: cubit.isDrawerCollapsed
                        ? null
                        : (e) {
                            cubit.openDrawer();
                          },
                  )
                ],
              ),
            ),
            borderRadius: cubit.isDrawerCollapsed
                ? BorderRadius.all(Radius.circular(0))
                : BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }
}

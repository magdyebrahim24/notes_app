import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/favorite.dart';
import 'package:notes_app/layout/home/home.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/verify/create_pass.dart';
import 'package:notes_app/verify/login.dart';
import 'package:notes_app/layout/setting/setting.dart';
import 'package:notes_app/layout/dashboard/bloc/app_cubit.dart';
import 'package:notes_app/layout/dashboard/bloc/app_states.dart';

final Color backgroundColor = Color(0xFF4A4A58);

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
                backgroundColor: backgroundColor,
                body: Stack(
                  children: [
                    menu(context,
                        rebuildFunction: () => cubit.getDataAndRebuild(),
                        menuScaleAnimation: cubit.drawerMenuScaleAnimation,
                        slideAnimation: cubit.drawerSlideAnimation),
                    dashboard(context, cubit: cubit),
                  ],
                ),
              );
            }));
  }

  Widget menu(context, {slideAnimation, menuScaleAnimation, rebuildFunction}) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 50),
                    width: .5 * screenWidth!,
                    child: Text(
                      'Notes',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )),
                _drawerItem(
                    text: 'Setting',
                    leading: Icons.settings,
                    fun: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Setting()))),
                _drawerItem(
                    text: 'Secret',
                    leading: Icons.lock_open_outlined,
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
                    text: 'Favorite',
                    leading: Icons.stars,
                    fun: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoriteScreen(),
                            )).then((value) {
                          rebuildFunction();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({text, leading, fun}) {
    return SizedBox(
      width: 0.5 * screenWidth!,
      child: Column(
        children: [
          ListTile(
            title:
                Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
            leading: Icon(
              leading,
              color: Colors.white,
            ),
            onTap: fun,
          ),
          Divider(color: Colors.white60, indent: 15, endIndent: 20),
        ],
      ),
    );
  }

  Widget dashboard(context, {cubit}) {
    return AnimatedPositioned(
      duration: cubit.drawerDuration,
      top: 0,
      bottom: 0,
      left: cubit.isDrawerCollapsed ? 0 : 0.4 * screenWidth!,
      right: cubit.isDrawerCollapsed ? 0 : -0.2 * screenWidth!,
      child: ScaleTransition(
        scale: cubit.drawerScaleAnimation!,
        child: Material(
          animationDuration: cubit.drawerDuration!,
          borderRadius: cubit.isDrawerCollapsed
              ? null
              : BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          // color: Theme.of(context).primaryColor,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
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
            borderRadius: cubit.isDrawerCollapsed
                ? BorderRadius.all(Radius.circular(0))
                : BorderRadius.all(Radius.circular(40)),
          ),
        ),
      ),
    );
  }
}
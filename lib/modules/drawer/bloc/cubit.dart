// import 'package:bloc/bloc.dart';
// import 'package:flutter/animation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes_app/modules/drawer/bloc/states.dart';
//
// class AppCubit extends Cubit<DrawerStates>{
//   AppCubit() : super(AppInitialState());
//
//   static AppCubit get(context) => BlocProvider.of(context);
//
//   bool isCollapsed = true;
//   final Duration? duration = const Duration(milliseconds: 200);
//   AnimationController? controller;
//   Animation<double>? scaleAnimation;
//   Animation<double>? menuScaleAnimation;
//   Animation<Offset>? slideAnimation;
//
//   void onStart(x) {
//     controller = AnimationController(vsync: x, duration: duration);
//     scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(controller!);
//     menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(controller!);
//     slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller!);
//   }
//
//   openDrawer(){
//     if (isCollapsed)
//       controller!.forward();
//     else
//       controller!.reverse();
//
//     isCollapsed = !isCollapsed;
//
//     emit(OpenDrawerState());
//   }
//
//   gestureDetectorOnTapFun(){
//
//   }
//
//
//
// }
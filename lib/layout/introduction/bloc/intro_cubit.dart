import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/dashboard/MenuDashboardPage.dart';
import 'package:notes_app/layout/introduction/bloc/intro_states.dart';
import 'package:notes_app/shared/cache_helper.dart';

class IntroCubit extends Cubit<IntroStates> {
  IntroCubit() : super(IntroInitialState());
  static IntroCubit get(context) => BlocProvider.of(context);

  PageController pageController = PageController();
  double currentPage = 0;

  onPageChanged (index) {
  currentPage = index.toDouble();
  emit(OnPageChangedState());
  }

  void nextBTN(context) async {
    if (currentPage == 2) {
      CacheHelper.putBool(key: 'intro', value: true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDashboardPage(),
          ));
    } else {
      pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}

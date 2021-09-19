

import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/speedDial_FAB/bloc/states.dart';

class SpeedDialFABCubit extends Cubit<SpeedDialFABStates> {
  SpeedDialFABCubit() : super(SpeedDialFABInitialState());

  static SpeedDialFABCubit get(context) => BlocProvider.of(context);


  late final AnimationController fabController;
  late final Animation<double> fabExpandAnimation;
  late final AnimationController fabAnimationIcon;

  bool isFABOpen = false;

  void onBuild(x,initialOpen){
    fabAnimationIcon = AnimationController(
      vsync: x,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );

    isFABOpen = initialOpen ?? false;
    fabController = AnimationController(
      value: isFABOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: x,
    );
    fabExpandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: fabController,
    );
  }



  void fABToggle() {

      isFABOpen = !isFABOpen;
      if (isFABOpen) {
        fabController.forward();
        fabAnimationIcon.forward();
      } else {
        fabController.reverse();
        fabAnimationIcon.reverse();
      }
      emit(ToggleState());
  }


  @override
  Future<void> close() {
    fabController.dispose();
    return super.close();
  }
}



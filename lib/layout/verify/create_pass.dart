import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/verify/bloc/state.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'package:notes_app/shared/components/shake_animation.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'bloc/cubit.dart';

class CreatePass extends StatelessWidget {
  final id;
  final table;
  final loginShakeKey = GlobalKey<ShakeWidgetState>();

  CreatePass({this.id, this.table});
  @override
  build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var them = Theme.of(context).textTheme;

    return BlocProvider(
      create: (BuildContext context) => LoginCubit()..onBuild(),
      child: BlocConsumer<LoginCubit, VerifyStates>(
        listener: (context, state) {},
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,size: 20,),
                onPressed: () {Navigator.pop(context);},
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: size.width > 360 ? 360 : size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * .05,
                        ),
                        Image.asset('assets/images/password.png'),
                        SizedBox(
                          height: 30,
                        ),
                        cubit.inCorrectPassword ?  Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.5),
                          child: Text(
                            Languages.of(context)!.secret['confirmError'],
                            textAlign: TextAlign.center,
                            style: them.headline4!.copyWith(
                                fontSize: 18,fontWeight: FontWeight.w400),
                          ),
                        ) : Text(
                          cubit.verifyPass == null
                              ? Languages.of(context)!.secret['createPass']
                              : Languages.of(context)!.secret['confirmPass'],
                          style: them.headline4!.copyWith(
                              fontSize: 31, fontWeight: FontWeight.w400),
                        ) ,

                        ShakeWidget(
                            key: loginShakeKey,
                            shakeCount: 3,
                            shakeOffset: 10,
                            shakeDuration: Duration(milliseconds: 500),
                            child: shakePassword(cubit.passwordDigitsList.length)
                        ),
                        Center(
                          child: GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                    crossAxisSpacing: 23,
                                    mainAxisSpacing: 10,
                              ),
                              itemCount: 12,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < 9) {
                                  return IconForSecret(
                                    onPressed: () {
                                      cubit.createPassAndAddToSecrete(
                                          context: context,
                                          index: index,
                                          id: id,
                                          table: table,
                                      inCorrectPassAndShakeFun: (){
                                        loginShakeKey.currentState!.shake();
                                      }
                                      );
                                    },
                                    body: Text('${index + 1}',
                                        style: them.headline4!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    color: Theme.of(context).cardTheme.color,
                                  );
                                } else if (index == 11) {
                                  return cubit.verifyPass == null
                                      ? IconForSecret(
                                          body: Icon(
                                            Icons.check,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          onPressed: cubit.isCompleted ? ()=> cubit.goToVerify() : null,
                                          color: accentColor,
                                        )
                                      : SizedBox();
                                } else if (index == 9) {
                                  return IconForSecret(
                                    body: Icon(
                                      Icons.backspace_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    color: accentColor,
                                    onPressed: () {
                                      cubit.deleteEnteredPassDigit();
                                    },
                                  );
                                } else {
                                  return IconForSecret(
                                    onPressed: () {
                                      cubit.createPassAndAddToSecrete(
                                          context: context,
                                          index: -1,
                                          id: id,
                                          table: table,
                                          inCorrectPassAndShakeFun: (){
                                            loginShakeKey.currentState!.shake();
                                          });
                                    },
                                    body: Text('0',
                                        style: them.headline4!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal)),
                                    color: Theme.of(context).cardTheme.color,
                                  );
                                }
                              }),
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

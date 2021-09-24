import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/verify/bloc/state.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'package:notes_app/shared/components/shake_animation.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'bloc/cubit.dart';

class Login extends StatelessWidget {
  final isUpdate;
  final id;
  final table;
  Login({this.id, this.table, this.isUpdate});

  final loginShakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
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
                            Languages.of(context)!.secret['error'],
                            textAlign: TextAlign.center,
                            style: them.headline4!.copyWith(
                                fontSize: 18,fontWeight: FontWeight.w400),
                          ),
                        ) : Text(
                          Languages.of(context)!.secret['enterPass'],
                          style: them.headline4!.copyWith(
                              fontSize: 31,fontWeight: FontWeight.w400),
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
                              padding:
                              EdgeInsets.symmetric(horizontal: 40),
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
                                if (index <9) {
                                  return IconForSecret(
                                    onPressed: () {
                                      cubit.loginAndAddToSecret(
                                          index: index,
                                          context: context,
                                          id: id,
                                          table: table,
                                          isUpdate: isUpdate,
                                      inCorrectPassFun: (){
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
                                  return  SizedBox();
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
                                      cubit.loginAndAddToSecret(
                                          index: -1,
                                          context: context,
                                          id: id,
                                          table: table,
                                          isUpdate: isUpdate,
                                          inCorrectPassFun: (){
                                            loginShakeKey.currentState!.shake();
                                          }
                                      );
                                    },
                                    body: Text('0',
                                        style: them.headline4!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
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
Padding shakePassword(passwordDigitsList) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i < 5; i++)
          Container(
            margin: EdgeInsets.all(10),
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: passwordDigitsList >= i
                  ? accentColor
                  : Colors.transparent,
              border: Border.all(color: Color(0xff7D7D7D)),
              shape: BoxShape.circle,
            ),
          ),
      ],
    ),
  );
}
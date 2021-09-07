import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/verify/bloc/state.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'package:notes_app/shared/constants.dart';
import 'bloc/cubit.dart';

class Login extends StatelessWidget {
  final isUpdate;
  final id;
  final table;
  Login({this.id, this.table, this.isUpdate});
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
                          height: size.height * .07,
                        ),
                        IconButton(
                            onPressed: () {
                              cubit.z();
                            },
                            icon: Icon(Icons.remove)),
                        Container(
                          child: Image.asset('assets/images/password.png'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Enter Password',
                          style: them.headline4!.copyWith(
                              fontSize: 32, fontWeight: FontWeight.normal),
                        ),
                        Padding(
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
                                    color: cubit.passwordDigitsList.length >= i
                                        ? accentColor
                                        : Colors.transparent,
                                    border: Border.all(color: Colors.grey),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
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
                                          isUpdate: isUpdate);
                                    },
                                    body: Text('${index + 1}',
                                        style: them.headline4!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal)),
                                    color: them.headline2!.color,
                                  );
                                } else if (index == 11) {
                                  return  SizedBox();
                                } else if (index == 9) {
                                  return IconForSecret(
                                    body: Icon(
                                      Icons.backspace_outlined,
                                      size: 20,
                                      color: them.headline4!.color,
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
                                          table: table);
                                    },
                                    body: Text('0',
                                        style: them.headline4!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal)),
                                    color: them.headline2!.color,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/bloc/cubit.dart';
import 'package:notes_app/layout/secret/bloc/state.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';

class Secret extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var them = Theme.of(context).textTheme;

    return BlocProvider(
      create: (BuildContext context)=>SecretCubit(),
      child: BlocConsumer<SecretCubit,SecretStates>(
        listener: (context,state){},
        builder: (context,state){
          SecretCubit cubit =SecretCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: size.width > 360 ? 360 : size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * .3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (int i = 1; i < 5; i++)
                              Container(
                                margin: EdgeInsets.all(10),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: cubit.password.length >=i ? Colors.grey:Colors.transparent,
                                  border: Border.all(color: Colors.grey),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            SizedBox(width: 60,),
                            IconButton(
                                onPressed: () {
                                  cubit.removeFromList();
                                },
                                icon: Icon(
                                  Icons.backspace_outlined,
                                  size: 28,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        Center(
                          child: GridView.builder(
                              padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                // mainAxisSpacing: 10,
                                // crossAxisSpacing: 30,
                              ),
                              itemCount: 9,
                              itemBuilder: (BuildContext context, int index) {
                                return IconForSecret(
                                  onPressed: () {
                                    cubit.addToList(index);
                                  },
                                  body: (index + 1).toString(),
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconForSecret(
                              body: '0',
                              onPressed: (){cubit.addToList(-1);},
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'BACK',
                                style: them.headline6,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            )
                          ],
                        )
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

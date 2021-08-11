import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'package:notes_app/verify/bloc/state.dart';
import 'bloc/cubit.dart';

class Verify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var them = Theme.of(context).textTheme;

    return BlocProvider(
      create: (BuildContext context)=>VerifyCubit()..onBuild(),
      child: BlocConsumer<VerifyCubit,VerifyStates>(
        listener: (context,state){},
        builder: (context,state){
          VerifyCubit cubit =VerifyCubit.get(context);
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
                        IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Verify()));}, icon: Icon(Icons.check)),
                        Text(cubit.isCreated?'Login':'Create Password',style: them.headline4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (int i = 1; i < 5; i++)
                              Container(
                                margin: EdgeInsets.all(10),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: cubit.passwordDigitsList.length >=i ? Colors.grey:Colors.transparent,
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
                                    cubit.addToList(index,context);
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
                              onPressed: (){cubit.addToList(-1,context);},
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

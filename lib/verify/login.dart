import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'package:notes_app/verify/bloc/state.dart';
import 'bloc/cubit.dart';

class Login extends StatelessWidget {
  final isUpdate;
  final id;
  final table;
  Login({this.id,this.table,this.isUpdate});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var them = Theme.of(context).textTheme;

    return BlocProvider(
      create: (BuildContext context)=>LoginCubit()..onBuild(),
      child: BlocConsumer<LoginCubit,VerifyStates>(
        listener: (context,state){},
        builder: (context,state){
          LoginCubit cubit =LoginCubit.get(context);
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
                          height: size.height * .22,
                        ),
                        IconButton(onPressed: (){cubit.z();}, icon: Icon(Icons.remove)),
                        Text('Enter Password',style: them.headline4,),
                        SizedBox(height: 10,),
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
                                  color: them.headline6!.color,
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
                                    cubit.loginAndAddToSecret(index:index,context:context,id: id,table: table,isUpdate: isUpdate);
                                  },
                                  body: (index + 1).toString(),
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 37),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconForSecret(
                                body: '0',
                                onPressed: (){cubit.loginAndAddToSecret(index:-1,context:context,id: id,table: table,isUpdate: isUpdate);},
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
                          ),
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

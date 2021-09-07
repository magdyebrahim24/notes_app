import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/verify/bloc/state.dart';
import 'package:notes_app/shared/components/icon_for_secret.dart';
import 'bloc/cubit.dart';

class CreatePass extends StatelessWidget {
  final id;
  final table;
  CreatePass({this.id,this.table});
  @override
  build(BuildContext context) {
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
                        IconButton(onPressed: (){if(cubit.isCompleted)cubit.goToVerify();}, icon: Icon(Icons.check,color: Colors.white,size: 30,)),
                        Text(cubit.verifyPass==null?'Create Password':'Confirm Password',style: them.headline4,),
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
                                  cubit.deleteEnteredPassDigit();
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
                                    cubit.createPassAndAddToSecrete(context:context,index:index,id:id,table: table);
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
                              cubit.verifyPass==null ? IconButton(onPressed: (){cubit.goToVerify();}, icon: Icon(Icons.check,color: Colors.white,size: 30,)):SizedBox(),
                              SizedBox(width: 30,),
                              IconForSecret(
                                body: '0',
                                onPressed: (){cubit.createPassAndAddToSecrete(context:context,index:-1,id:id,table: table);},
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

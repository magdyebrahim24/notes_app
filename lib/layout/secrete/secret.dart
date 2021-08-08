import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secrete/bloc/cubit.dart';
import 'package:notes_app/layout/secrete/bloc/states.dart';

class Secret extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SecretCubit()..onBuild(),
      child: BlocConsumer<SecretCubit,SecretStates>(
        listener: (context,state){},
        builder: (context,state){
          SecretCubit cubit = SecretCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: ListView.builder(
                itemCount: cubit.notes.length,
                itemBuilder: (context,index){
                  return Text('asdf',style: TextStyle(color: Colors.white,fontSize: 25),);
                }
            ),
          );
        },
      ),
    );
  }
}

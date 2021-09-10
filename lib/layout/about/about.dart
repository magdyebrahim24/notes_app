import 'package:flutter/material.dart';
import 'package:notes_app/layout/introduction/intro_page.dart';
import 'package:notes_app/layout/terms_of_use/terms_of_use.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'About',
          style: theme.headline5!.copyWith(fontSize: 20) ,
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 20,),onPressed: ()=> Navigator.pop(context),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric( vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             ListTile(
               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IntroPage(),)),
               title: Text('On Boarding Page',style: theme.headline5!.copyWith(fontSize: 20,),),
               trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
               contentPadding: EdgeInsets.symmetric(horizontal: 25),
             ),
              divider(),
              title('APP Info' ,context),
              subtext(
                "These Terms of Use govern your use of MEGA MAR,and any information, text, graphics, photos or other materials uploaded, downloaded or appearing on the the medical solution,referencing these Terms. You can’t use our the medical solution  unless you agree to them, so please read them carefully. Before using any of the the medical solution , you are required to read, understand and agree to these terms. You may only access the medical solution after reading and accepting these Terms of Use.",
              ),

               ],
          ),
        ),
      ),
    );
  }



}

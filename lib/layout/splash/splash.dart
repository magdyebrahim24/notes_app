import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/layout/dashboard/MenuDashboardPage.dart';
import 'package:notes_app/layout/introduction/intro_page.dart';
import 'package:notes_app/shared/cache_helper.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3) , checkFirstSeen);
  }
  Future checkFirstSeen() async {
    final _intro =  CacheHelper.getBool(key: 'intro');

    if (_intro != true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroPage()));
    }else{
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MenuDashboardPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 65,
          alignment: Alignment.center,
          child: Text('Splash Screen',style: Theme.of(context).textTheme.headline4,),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage(
            //     'assets/logo.png',
            //   ),
            //   // fit: BoxFit.cover,
            // ),
          ),
        ),
      ),
    );
  }
}

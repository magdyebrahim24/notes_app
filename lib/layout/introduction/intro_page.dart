import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController = PageController();
  double currentPage = 0;
  List introImages = [
    'assets/intro/notes.png',
    'assets/intro/tasks.png',
    'assets/intro/memories.png',
  ];
  List text = [
    {
      'title' : 'Notes',
      'body' : 'You can write whatever you want, put a picture or an audio recording to hear it whenever you want !'
    },
    {
      'title' : 'Tasks',
      'body' : 'Add your Missions as a task to motivate you to complete them and organize your tasks'
    },
    {
      'title' : 'Memories',
      'body' : 'Put all your memories here to always remember them whenever you want!'
    },
  ];


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: PageView.builder(
        physics: PageScrollPhysics(),
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(introImages[index].toString(),fit: BoxFit.fitWidth,),
                    Text(
                        text[index]['title'],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline4
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 39),
                      child: Text(
                        text[index]['body'],
                        style: theme.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            currentPage = index.toDouble();
          });
        },
      ),
      bottomNavigationBar: currentPage != 2
          ? BottomAppBar(
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 3; i++)
                          Container(
                            width: currentPage == i ? 30 : 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.accentColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: currentPage == i
                                  ? theme.accentColor
                                  : Colors.transparent,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '${currentPage.toInt() + 1}/3',
                      // style: TextStyle(color: greyColor),
                    ),
                    MaterialButton(
                      onPressed: () => _pageController.nextPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeIn),
                      // color: primaryColor,
                      elevation: 3.0,
                      hoverElevation: 5.0,
                      padding: EdgeInsets.all(0),
                      // splashColor: primaryColor.withOpacity(.65),
                      minWidth: 50,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            )
          : BottomAppBar(
              elevation: 0.0,
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(right: 40, left: 40, bottom: 20, top: 10),
                child: MaterialButton(
                  onPressed: () {},

                  child: Text('Get Started'),
                  // borderRadious: 10,
                  // minWdthRatio: .8,
                ),
              ),
            ),
    );
  }
}

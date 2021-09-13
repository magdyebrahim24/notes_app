
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          'People who reacted',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [IconButton(onPressed: showFullComments, icon: Icon(Icons.search,color: Colors.black,))],
      ),
      body: ListView.builder(
        itemCount: 20,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Magdy Ebrahim',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${index * 2 + 2} mutual friends',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              index % 3 != 0
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'Add Friend',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                    )
                  : SizedBox(),
              SizedBox(
                width: 15,
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.photo_library_outlined,
                color: Colors.green.shade400,
              ),
              Icon(
                Icons.person_add_alt_1,
                color: Colors.blue.shade900,
              ),
              Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.orange.shade400,
              ),
              Icon(
                Icons.location_on,
                color: Colors.red.shade400,
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.pending,color: Colors.grey,))
            ],
          ),
        ),

      ),
    );
  }

  void showFullComments() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 20),
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        MaterialButton(onPressed: (){},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          padding: EdgeInsets.zero,child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.thumb_up_alt_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2)),
                            ),
                            SizedBox(width: 5,),
                            Text('522',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            Icon(Icons.arrow_forward_ios_outlined,size: 20,)
                          ],
                        ),),
                        Spacer(),
                        IconButton(onPressed: (){showFullComments();}, icon: Icon(Icons.thumb_up_alt_outlined),)

                      ],
                    ),
                    Divider()
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}




/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (context, {onStepCancel, onStepContinue}) {
        return Icon(Icons.ac_unit);
      },
      steps: <Step>[
        Step(
          subtitle: Icon(Icons.ac_unit),
          title: const Text('Step 1 title'),
          isActive: true,
          content: Container(
              alignment: Alignment.centerLeft,
              child: const Text('Content for Step 1')),
        ),
        const Step(
          title: Text('Step 2 title'),
          content: Text('Content for Step 2'),
        ),
        const Step(
          title: Text('Step 2 title'),
          content: Text('Content for Step 2'),
        ),
        Step(
          title: Text('Step 2 title'),
          content: Text('Content for Step 2'),
        ),
      ],
    );
  }
}

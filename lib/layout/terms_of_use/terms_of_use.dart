import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Terms Of Use',
          style: theme.headline5!.copyWith(fontSize: 20) ,
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 20,),onPressed: ()=>Navigator.pop(context),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric( vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title('Terms Of Use' ,context),
              subtext(
                "These Terms of Use govern your use of MEGA MAR,and any information, text, graphics, photos or other materials uploaded, downloaded or appearing on the the medical solution,referencing these Terms. You can’t use our the medical solution  unless you agree to them, so please read them carefully. Before using any of the the medical solution , you are required to read, understand and agree to these terms. You may only access the medical solution after reading and accepting these Terms of Use.",
              ),
              divider(),
              title('Privacy' ,context ),
              subtext(
                "The medical solution Privacy Policy is incorporated into these Terms. By accepting these Terms, you agree to the collection, use, and sharing of your information through the Services in accordance with the Privacy Policy,",
              ),
              divider(),
              title('User Content' ,context),
              subtext(
                "The Services consist of interactive features and areas that allow users to create, post, transmit, and/or store content, including but not limited to photos, videos, text, graphics, items, or other materials (collectively,) . You understand that you are responsible for all data charges you incur by using the Services. You also understand that your User Content may be viewable by others and that you have the ability to control who can access such content by adjusting your privacy settings. And you agree to abide by our Community Guidelines, which may be updated from time to time.",
              ),
              divider(),
              title('Feedback' ,context),
              subtext(
                  "You agree that any feedback, suggestions, ideas, or other information or materials regarding SNOW or the Services that you provide, whether by email or otherwise (Feedback), are non-confidential and shall become the sole property of SNOW. We will be entitled to the unrestricted use and dissemination of such Feedback for any purpose, commercial or otherwise, without acknowledging or compensating you. You waive any rights you may have to the Feedback (including any copyrights or moral rights). We like hearing from users, but please do not share your ideas with us if you expect to be paid or want to continue to own or claim rights in them.")
            ],
          ),
        ),
      ),
    );
  }




}
 Padding divider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Divider(
      thickness: 1,
      height: 1,
      indent: 20,
      endIndent: 20,
    ),
  );
}
Widget title(String text, context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
    child: Text(
      text,
      style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20,),
    ),
  );
}

Widget subtext(String text) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      text,
      style: TextStyle(
          color: Color(0xff7D7D7D),
          fontSize: 16
      ),
    ),
  );
}
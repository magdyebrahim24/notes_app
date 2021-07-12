import 'package:flutter/material.dart';

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){},
      icon: Icon(Icons.arrow_back_ios),),),

      body: Column(
        children: [
          TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Tittle',disabledBorder: InputBorder.none,

            ) ,
          )
        ],
      ),
    );
  }
}

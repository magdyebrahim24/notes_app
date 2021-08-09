
import 'package:flutter/material.dart';
class MemoriesCard extends StatelessWidget {
  final data;

  const MemoriesCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(data['title'],style: TextStyle(color: Colors.white),),
    );
  }
}

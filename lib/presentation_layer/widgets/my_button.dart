import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/utils.dart';

class MyButton extends StatefulWidget {
  const MyButton({super.key,required this.title,required this.onPress});
  final String title;
  final onPress;


  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        height: 50,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadiusDirectional.circular(kPadding)
        ),
        child:Text(
          '${widget.title}',
          style:const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

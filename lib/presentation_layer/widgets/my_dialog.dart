import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/utils.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });
  final String title;
  final String content;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(kPadding)
      ),
      title: Text('$title',style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold,fontSize: 20),),
      content: Text('$content',style:const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
      actions: [
        TextButton(onPressed:onPressed , child: Text('Open',style: TextStyle(color: Colors.blue[800]),)),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Close',style: TextStyle(color: Colors.blue[800])))

      ],
    );
  }
}

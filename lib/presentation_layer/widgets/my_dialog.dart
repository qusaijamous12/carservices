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
      title: Text('$title',style:const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 20),),
      content: Text('$content',style:const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
      actions: [
        TextButton(onPressed:onPressed , child:const Text('Open')),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child:const Text('Close'))

      ],
    );
  }
}

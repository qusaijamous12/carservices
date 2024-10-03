import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast{

  static showToast({required String title})=>Fluttertoast.showToast(
      msg: "$title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0
  );

}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_car_services/presentation_layer/screens/on_board_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer ?_time;

  _onTimeFinish(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OnBoardingScreen()), (x)=>false);

  }

  @override
  void initState() {
    _time=Timer(const Duration(seconds: 2), _onTimeFinish);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}

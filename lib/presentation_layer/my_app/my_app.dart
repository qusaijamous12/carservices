import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/cubit.dart';

import '../../buisness_logic_layer/login_bloc/cubit.dart';
import '../../buisness_logic_layer/register_cubit/cubit.dart';
import '../screens/car_details.dart';
import '../screens/login_screen.dart';
import '../screens/on_board_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=>LoginCubit()),
        BlocProvider(create: (BuildContext context)=>RegisterCubit()),
        BlocProvider(create: (BuildContext context)=>MapCubit()),
        BlocProvider(create: (BuildContext context)=>ServicesCubit()),



      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:OnBoardingScreen() ,
      ),
    );
  }
}
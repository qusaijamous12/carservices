import 'package:flutter/material.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/presentation_layer/screens/map_screen.dart';
import 'package:task_car_services/presentation_layer/screens/station_owner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit=LoginCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body:cubit.loginModel.status==1?const StationOwnerScreen():const MapScreen() ,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/state.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/cubit.dart';
import 'package:task_car_services/presentation_layer/screens/login_screen.dart';
import 'package:task_car_services/presentation_layer/screens/map_screen.dart';
import 'package:task_car_services/presentation_layer/screens/station_owner_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_button.dart';
import 'package:task_car_services/shared/utils/utils.dart';

import '../../buisness_logic_layer/map_cubit/cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,required this.uid});
   final String uid;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    if(LoginCubit.get(context).loginModel.status==2){
      MapCubit.get(context).getMyLocation(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerKey=GlobalKey<ScaffoldState>();
    var cubit=LoginCubit.get(context);
    return Scaffold(
      key: drawerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('${cubit.loginModel.status==1?'Car Station':'Map Screen'}',style:const TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: (){
          drawerKey.currentState!.openDrawer();
        }, icon:const Icon(Icons.menu),color: Colors.white,),
      ),
      body:cubit.loginModel.status==1?const StationOwnerScreen():const MapScreen() ,
      drawer: BlocBuilder<LoginCubit,LoginState>(
        builder: (context,state){
          return  Drawer(
            backgroundColor: Colors.blue.withOpacity(0.4),
            child: SafeArea(
              child: Container(
                width: 600,
                padding:const EdgeInsetsDirectional.only(top: kPadding,start: kPadding,end: kPadding,bottom: kPadding*5),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsEJHmI0MlIGvH9CYkbsLEWQ5_ee8Qtl5V-Q&s'),
                          radius: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                      Text(
                      'Name:${cubit.loginModel.userName}',
                      style:const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      height: kPadding*4,
                    ),
                    MyButton(title: 'LogOut', onPress: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (x)=>false);
                    })


                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}

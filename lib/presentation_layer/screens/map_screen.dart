import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/presentation_layer/screens/add_my_cars.dart';
import 'package:task_car_services/presentation_layer/screens/service_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_dialog.dart';

import '../../buisness_logic_layer/map_cubit/state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});



  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    var cubit=MapCubit.get(context);

    return  BlocBuilder<MapCubit,MapState>(
      builder: (context,state){
        return  ConditionalBuilder(
            condition: state is !LoadingGetMyLocation && cubit.stationServices.isNotEmpty,
            builder: (context)=> Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:cubit.myCameraPosition,
                  markers:{
                    for(int i=0;i<cubit.stationServices.length;i++)...{
                      Marker(markerId: MarkerId('$i'),
                        position: LatLng(cubit.stationServices[i].latitude!, cubit.stationServices[i].longtitue!),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        onTap: (){
                        showDialog(context: context, builder: (context)=>MyDialog(title: '${cubit.stationServices[i].userName !+' Station' }', content: 'Services', onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesScreen(staionName: cubit.stationServices[i].userName,uid: cubit.stationServices[i].uid!,)));
                        }));
                        }
                      )
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddMyCars()));
                      },child:const Icon(Icons.add,color:Colors.white,),backgroundColor: Colors.blue,),
                    ))
              ],
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.blue,)));
      },
    );
  }
}

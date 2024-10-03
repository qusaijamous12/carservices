import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/state.dart';
import 'package:task_car_services/shared/my_location/locator.dart';

import '../../data_layer/model/login_model.dart';

class MapCubit extends Cubit<MapState>{

  MapCubit():super(InitialMapState());

  static MapCubit get(context)=>BlocProvider.of(context);

  late CameraPosition myCameraPosition ;

  late Position myPosition;

  List<LoginModel> stationServices=[];

  final Set<Marker> markers = {};

  void getMyLocation(BuildContext context) async {
    emit(LoadingGetMyLocation());
    await GetMyLocation.determindePosition.then((value) async {
      myPosition = value;
      print('My LOCATION IS ${value.latitude} + ${value.longitude}');
      myCameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      await getStationPlaces(); // Pass the context here
    }).catchError((error) {
      print('there is an error in get my location $error');
      emit(GetMyLocationErrorState());
    });
  }

  Future getStationPlaces() async {
    stationServices=[];
        FirebaseFirestore.instance.collection('users').get().then((value){
         value.docs.forEach((element){
           if(element['status']==1){
             stationServices.add(LoginModel.fromJson(element.data()));
           }

         });
         print(stationServices.length);
         emit(GetMyLocationSuccessState());
         emit(GetStationPlacesSuccessState());


       }).catchError((error){
         print('there is an error in get station services is $error');
         emit(GetStationPlacesErrorState());
       });


  }



}
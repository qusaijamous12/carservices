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
import '../../data_layer/model/message_model.dart';

class MapCubit extends Cubit<MapState>{

  MapCubit():super(InitialMapState());

  static MapCubit get(context)=>BlocProvider.of(context);

  late CameraPosition myCameraPosition ;

  late Position myPosition;

  List<LoginModel> stationServices=[];

  final Set<Marker> markers = {};

  List<MessageModel> messages=[];

  void getMyLocation(BuildContext context) async {
    emit(LoadingGetMyLocation());
    await GetMyLocation.determindePosition.then((value) async {
      myPosition = value;

      print('My LOCATION IS ${value.latitude} + ${value.longitude}');

      myCameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      await getStationPlaces();

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




  void sendMessage(context,{
    required String receiverId,
    required String dateTime,
    required String text,
    String ?image


  }){
    MessageModel messageModel = MessageModel(
      text: text,
      dateTime: dateTime,
      senderId: LoginCubit.get(context).uid,
      reciverId: receiverId,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(LoginCubit.get(context).uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModel.toMap()).then((value) {
      emit(SendMessageSuccessState());

    }).catchError((error){
      print('error is send message $error');
      emit(SendMessageErrorState());

    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(LoginCubit.get(context).uid)
        .collection('message')
        .add(messageModel.toMap()).then((value) {
      emit(SendMessageSuccessState());

    }).catchError((error){
      print('error in send message $error');
      emit(SendMessageErrorState());

    });


  }

  void getMessages(context,{required String receiverId}){
    FirebaseFirestore.instance.
    collection('users').
    doc(LoginCubit.get(context).uid).
    collection('chats').
    doc(receiverId).
    collection('message').orderBy('dateTime').
    snapshots()
        .listen((event) {
      messages=[];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));


      });
      emit(GetMessageSuccessState());

    });
  }



}
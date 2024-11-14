import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/state.dart';
import 'package:task_car_services/data_layer/model/my_cars_model.dart';
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
    myPosition =await determinePosition();
    myCameraPosition = CameraPosition(
      target: LatLng(myPosition.latitude, myPosition.longitude),
      zoom: 14,
    );

     await getStationPlaces();

    // await GetMyLocation.determinePosition().then((value) async {
    //   myPosition =await determinePosition();
    //
    //   myCameraPosition = CameraPosition(
    //     target: LatLng(myPosition.latitude, myPosition.longitude),
    //     zoom: 14,
    //   );
    //
    //
    //
    //   emit(GetMyLocationSuccessState());
    //
    // }).catchError((error) {
    //   print('there is an error in get my location $error');
    //   emit(GetMyLocationErrorState());
    // });
  }

  Future<void> getStationPlaces() async {
    stationServices=[];
   final result= await  FirebaseFirestore.instance.collection('users').get();
   if(result!=null){
     result.docs.forEach((value){
       if(value['status']==1){
         stationServices.add(LoginModel.fromJson(value.data()));
       }
     });
     emit(GetMyLocationSuccessState());
     emit(GetStationPlacesSuccessState());
   }else{
     print('there is an error in get station services is');
     emit(GetStationPlacesErrorState());

   }
   //then((value){
  //        value.docs.forEach((element){
  //          if(element['status']==1){
  //            stationServices.add(LoginModel.fromJson(element.data()));
  //          }
  //
  //        });
  //        print(stationServices.length);
  //        emit(GetMyLocationSuccessState());
  //        emit(GetStationPlacesSuccessState());
  //
  //
  //      }).catchError((error){
  //        print('there is an error in get station services is $error');
  //        emit(GetStationPlacesErrorState());
  //      });


  }

  bool addMyCarsFireStore(context,{required String carName,required String carNumber}){
emit(LoadingAddMyCarState());
    FirebaseFirestore.instance.collection('users').doc(LoginCubit.get(context).uid).collection('MyCars').add({
  'car_name':carName,
  'car_number':carNumber
}).then((value){
      emit(AddMyCarsSuccessState());
    }).catchError((error){
      print('there is an error in add my car $error');
      emit(AddMyCarsErrorState());
      return false;
    });
    return true;

  }

  List<MyCarsModel> myCars=[];

  Future<void> getMyCars(context)async{
    myCars.clear();

    emit(LoadingGetMyCarsState());

    final result=FirebaseFirestore.instance.collection('users').doc(LoginCubit.get(context).uid).collection('MyCars').get().then((value){
      value.docs.forEach((element){
        myCars.add(MyCarsModel.fromJson(element.data()));

      });
      print(myCars[0].carNumber);
      print(myCars.length);
      emit(GetMyCarsSuccessState());

    }).catchError((error){

      print('there is an error in get my cars $error');
      emit(GetMyCarsErrorState());
    });

  }


  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }


  void sendMessage(context,{required String receiverId, required String dateTime, required String text, String ?image}){
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
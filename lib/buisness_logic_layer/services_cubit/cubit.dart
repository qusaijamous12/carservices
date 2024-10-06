import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/state%5D.dart';
import 'package:task_car_services/data_layer/model/service_model.dart';

class ServicesCubit extends Cubit<ServicesState>{

  ServicesCubit():super(InitialServicesState());

  static ServicesCubit get(context)=>BlocProvider.of(context);


  List<ServiceModel> services=[];

  Future getAllServices({required String uid})async{
    services.clear();
   await  FirebaseFirestore.instance.collection('users').doc(uid).collection('services').get().then((value){
      value.docs.forEach((element){
        services=[];
        services.add(ServiceModel.fromJson(element.data()));

      });
      emit(GetAllServicesSuccecssState());

    }).catchError((error){
      print('there is an error in get a;; services $error');
      emit(GetAllServicesErrorState());
    });

  }

}
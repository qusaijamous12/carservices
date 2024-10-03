import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/register_cubit/state.dart';
import 'package:task_car_services/data_layer/model/login_model.dart';

class RegisterCubit extends Cubit<RegisterState>{

  RegisterCubit():super(InitialRegisterState());

  static RegisterCubit get(context)=>BlocProvider.of(context);
  late LoginModel loginModel;
  dynamic uid;

  Future createAccount({required String email,required String password,required String phoneNumber,required String userName,required int status,double ?lattiude=0,double ?longtitude=0})async{
    emit(LoadingRegisterState());
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value)async{
      uid=value.user!.uid;
     await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
        'uid':value.user!.uid,
        'email':email,
        'user_name':userName,
        'phone_number':phoneNumber,
        'lattiude':lattiude,
        'longtitude':longtitude,
       'status':status
      }).then((value){
        loginModel=LoginModel(userName, email, status, lattiude, longtitude, phoneNumber,uid);

        emit(RegisterSuccessState());
        emit(AddDataToFireStoreSuccessState());
      }).catchError((error){
        print('there is an error in add the data to firestore $error');
        emit(AddDataToFireStoreErrorState());
      });




    }).catchError((error){
      print('there is an error in register $error');
      emit(RegisterErrorState());

    });

  }


}
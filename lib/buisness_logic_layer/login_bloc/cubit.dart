import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/state.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/cubit.dart';
import 'package:task_car_services/data_layer/model/login_model.dart';
import 'package:task_car_services/presentation_layer/widgets/my_dialog.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';

class LoginCubit extends Cubit<LoginState>{

  LoginCubit():super(InitialLoginState());

  static LoginCubit get(context)=>BlocProvider.of(context);

  late LoginModel loginModel;


  dynamic ?uid;

  void loginInWithEmailAndPassword(context,{required String email,required String password}){

    emit(LoadingLoginState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value)async{
      if(value.user!.uid!=null){
        uid=value.user!.uid;
        await getUserData(context,uid: value.user!.uid);
        emit(LoginSuccessState());

       // await ServicesCubit.get(context).getAllServices(uid: uid);

      }

    }).catchError((error){

      print('there is an error in login $error');
      emit(LoginErrorState());

    });

  }

  Future getUserData(context,{required dynamic uid})async {

   await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value)async{
      if(value.data()!=null) {
        loginModel = LoginModel.fromJson(value.data()!);
        if(loginModel.status==1){
          await ServicesCubit.get(context).getAllServices(uid: loginModel.uid!);

        }

        emit(GetUserDataSuccessState());
      }

    }).catchError((error){
      print('there is an error when get user data $error');
      emit(GetUserDataErrorState());
    });

  }

  void forgetPassword({required String email}){
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      MyToast.showToast(title: 'Password reset email sent!');


    }
    catch(error){
      print('there is an error $error');
    }
  }




}
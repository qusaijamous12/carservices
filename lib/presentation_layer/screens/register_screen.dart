import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/register_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/register_cubit/state.dart';
import 'package:task_car_services/presentation_layer/screens/login_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';

import '../../shared/utils/utils.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});



  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> roles=['Station Owner','Car Owner'];
  String ?selectedRole;
  final  emailController=TextEditingController();
  final passwordController=TextEditingController();
  final phoneNumberController=TextEditingController();
  final userNameController=TextEditingController();
  final latitudeController=TextEditingController();
  final longtitudeController=TextEditingController();

  var formKey=GlobalKey<FormState>();
  @override
  void initState() {
    latitudeController.text='0';
    longtitudeController.text='0';

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cubit=RegisterCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:const EdgeInsetsDirectional.only(start: kPadding,end: kPadding,bottom: kPadding,top: kPadding*3),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Register'
                  ,
                  style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                  ),),
                const SizedBox(
                  height:kPadding/4 ,
                ),
                Text(
                  'Enter your information to register...',
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 30
                  ),
                ),
                const SizedBox(
                  height: kPadding*2,
                ),
                MyTextFormField(textController: userNameController, hintText: 'User Name',prefixIcon:const Icon(Icons.person_2_outlined),keyBoardType: TextInputType.text,),
                const SizedBox(
                  height:kPadding ,
                ),
                MyTextFormField(textController: emailController, hintText: 'Email Address',prefixIcon:const Icon(Icons.email_outlined),keyBoardType: TextInputType.emailAddress,),
                const SizedBox(
                  height:kPadding ,
                ),
                MyTextFormField(textController: phoneNumberController, hintText: 'Phone Number',prefixIcon:const Icon(Icons.phone),keyBoardType: TextInputType.phone,),
                const SizedBox(
                  height:kPadding ,
                ),
                MyTextFormField(textController: passwordController, hintText: 'Password',prefixIcon:const Icon(Icons.lock_outline),keyBoardType: TextInputType.visiblePassword,),
                const SizedBox(
                  height:kPadding ,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Role',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(
                      height: kPadding / 2,
                    ),
        
                    Container(
                      width: double.infinity,
                      padding:const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonFormField<String>(
                        padding: EdgeInsetsDirectional.zero,
                        isExpanded: true, // Expands to fill the width
                        decoration:const InputDecoration(
                          border: InputBorder.none,
        
                        ),
                        value: selectedRole,
                        hint:const Text('Enter your Role'),
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if(selectedRole=='Station Owner')
                  const SizedBox(
                    height:kPadding ,
                  ),
        
                if(selectedRole=='Station Owner')
                  Row(
                    children: [
                      Expanded(child: MyTextFormField(textController:latitudeController , hintText: 'Latitude', prefixIcon:const Icon(Icons.location_on_outlined),keyBoardType: TextInputType.phone,)),
                      const SizedBox(
                        width: kPadding/4,
                      ),
                      Expanded(child: MyTextFormField(textController:longtitudeController , hintText: 'Longtitude', prefixIcon:const Icon(Icons.location_on_outlined),keyBoardType: TextInputType.phone,))
        
                    ],
                  ),
        
                const SizedBox(
                  height: kPadding*3,
                ),
                BlocConsumer<RegisterCubit,RegisterState>(
                 listener:(context,state){
                   if(state is RegisterSuccessState){
                     MyToast.showToast(title: 'Create Account Success');
                   }
                   else if(state is RegisterErrorState || state is AddDataToFireStoreErrorState){
                     MyToast.showToast(title: 'There is an error ! ');
                   }
        
                 } ,
                 builder:(context,state){
                   return ConditionalBuilder(
                       condition: state is !LoadingRegisterState,
                       builder: (context)=>MyButton(title: 'Register', onPress: (){
                         if(userNameController.text.isEmpty||emailController.text.isEmpty||phoneNumberController.text.isEmpty||passwordController.text.isEmpty){
                           MyToast.showToast(title: 'All fields is required');
                         }
                         else{
                           cubit.createAccount(
                               email: emailController.text,
                               password: passwordController.text,
                               phoneNumber: phoneNumberController.text,
                               userName: userNameController.text,
                               lattiude:double.parse(latitudeController.text.toString()),
                               longtitude: double.parse( longtitudeController.text.toString()),
                               status: selectedRole=='Station Owner'?1:2).then((value){
                             emailController.text='';
                             passwordController.text='';
                             phoneNumberController.text='';
                             userNameController.text='';
                             setState(() {
        
                             });
                           });
                         }
        
                       }),
                       fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.blue,)));
                 } ,
               ),
                const SizedBox(
                  height: kPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account ?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (x)=>false);
                        },
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ))
                  ],
                ),
        
        
        
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/state.dart';
import 'package:task_car_services/presentation_layer/screens/home_screen.dart';
import 'package:task_car_services/presentation_layer/screens/register_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_button.dart';
import 'package:task_car_services/presentation_layer/widgets/my_text_form_field.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';

import '../../shared/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   final  emailController=TextEditingController();
   final passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit=LoginCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding:const EdgeInsetsDirectional.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Login'
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
                'Enter your credentials to login...',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
              const SizedBox(
                height: kPadding*2,
              ),
              MyTextFormField(textController: emailController, hintText: 'Email Address',prefixIcon:const Icon(Icons.email_outlined),keyBoardType: TextInputType.emailAddress,),
              const SizedBox(
                height:kPadding ,
              ),
              MyTextFormField(textController: passwordController, hintText: 'Password',prefixIcon:const Icon(Icons.lock_outline),keyBoardType: TextInputType.visiblePassword,),
              const SizedBox(
                height: kPadding/2,
              ),
              TextButton(
                  onPressed: (){
                    if(emailController.text.isEmpty){
                      MyToast.showToast(title: 'Email is required');
                    }
                    else{
                      LoginCubit.get(context).forgetPassword(email: emailController.text);
                    }

                  },
                  child: Text(
                    'Forget password?',
                     style:  TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      )
                  )),
              const SizedBox(
                height: kPadding*3,
              ),
              Row(
                children: [
                 const Text(
                    'Don\'t have an account ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()), (x)=>false);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: kPadding,
              ),
              BlocConsumer<LoginCubit,LoginState>(
                listener: (context,state){
                  if(state is LoginSuccessState || state is GetUserDataSuccessState){
                    MyToast.showToast(title: 'Login Success');
                    emailController.text='';
                    passwordController.text='';
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomeScreen(uid:LoginCubit.get(context).uid ,)), (x)=>false);

                  }
                  else if(state is LoginErrorState ||state is GetUserDataErrorState){
                    MyToast.showToast(title: 'Email or Password is Invalid');

                  }
                },
                builder: (context,state){
                  return ConditionalBuilder(
                      condition: state is !LoadingLoginState,
                      builder: (context)=>MyButton(title: 'Login', onPress: (){
                        cubit.loginInWithEmailAndPassword(context,email: emailController.text, password: passwordController.text);
                      }),
                      fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.blue,)));
                },
              )



            ],
          ),
        ),
      ),
    );
  }
}

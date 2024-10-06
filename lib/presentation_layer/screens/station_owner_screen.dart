import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/state%5D.dart';
import 'package:task_car_services/data_layer/model/service_model.dart';
import 'package:task_car_services/presentation_layer/screens/car_details.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';
import 'package:task_car_services/shared/utils/utils.dart';

class StationOwnerScreen extends StatefulWidget {
  const StationOwnerScreen({super.key});

  @override
  State<StationOwnerScreen> createState() => _StationOwnerScreenState();
}

class _StationOwnerScreenState extends State<StationOwnerScreen> {
  @override

  Widget build(BuildContext context) {
    var cubit=ServicesCubit.get(context);
    return SingleChildScrollView(
      physics:const BouncingScrollPhysics(),
      padding:const EdgeInsetsDirectional.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LoginCubit.get(context).loginModel.userName?.toUpperCase()} Station ',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize:28,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(
            height: kPadding*2,
          ),
         BlocBuilder<ServicesCubit,ServicesState>(
             builder: (context,state){
               return  ConditionalBuilder(
                   condition: cubit.services.length>0,
                   builder: (context)=>ListView.separated(
                       physics:const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemBuilder:(context,index)=>buildUserService(cubit.services[index]) ,
                       separatorBuilder: (context,index)=>const SizedBox(
                         height: kPadding,
                       ),
                       itemCount: cubit.services.length),
                   fallback: (context)=>const Center(child: Text('There is no Cars !',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500 ),)));
             })
        ],
      ),
    );
  }

  Widget buildUserService(ServiceModel model){
    return Dismissible(
      key: Key('${model.uid}'),
      onDismissed: (x){
        FirebaseFirestore.instance.collection('users').doc(LoginCubit.get(context).uid).collection('services').get().then((value){
          value.docs.forEach((element){
            if(element['car_number']==model.carNumber){
              element.reference.delete().then((value){
                MyToast.showToast(title: 'Delete Success');
                ServicesCubit.get(context).getAllServices(uid: LoginCubit.get(context).uid);
              }).catchError((error){MyToast.showToast(title: 'Error Delete');});
            }

          });
        });
      },
      child: GestureDetector(
        onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=> CarDetails(carName:model.carName!,carNumber: model.carNumber!,price: model.price!,services: model.services!,uid: model.uid,percenatge: model.percenatge,)));
        },
        child: Container(
          height: 130,
          padding:const EdgeInsetsDirectional.symmetric(horizontal: kPadding/2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadiusDirectional.circular(kPadding)
          ),
          child:  Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUFlo2IjF3ZPjaZKxkjSKJPQ6ZAsA-62OB6g&s'),
                radius: 40,

              ),
              const SizedBox(
                width: kPadding/4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Name : ${model.carName}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),
                    ),
                    Text(
                      'Car Number : ${model.carNumber}',
                      overflow: TextOverflow.ellipsis,
                      style:const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),
                    ),
                    Text(
                      'Services is : ${model.services}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

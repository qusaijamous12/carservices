import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/services_cubit/state%5D.dart';
import 'package:task_car_services/data_layer/model/service_model.dart';
import 'package:task_car_services/shared/utils/utils.dart';

class StationOwnerScreen extends StatefulWidget {
  const StationOwnerScreen({super.key});

  @override
  State<StationOwnerScreen> createState() => _StationOwnerScreenState();
}

class _StationOwnerScreenState extends State<StationOwnerScreen> {

  @override
  void initState() {

    ServicesCubit.get(context).getAllServices(uid: LoginCubit.get(context).uid);

    super.initState();
  }

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
            '${LoginCubit.get(context).loginModel.userName} ',
            style:const TextStyle(
              color: Colors.blue,
              fontSize:30,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(
            height: kPadding*2,
          ),
         BlocBuilder<ServicesCubit,ServicesState>(
             builder: (context,state){
               return  ConditionalBuilder(
                   condition: cubit.services.isNotEmpty,
                   builder: (context)=>ListView.separated(
                       physics:const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemBuilder:(context,index)=>buildUserService(cubit.services[index]) ,
                       separatorBuilder: (context,index)=>const SizedBox(
                         height: kPadding,
                       ),
                       itemCount: cubit.services.length),
                   fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.blue,)));
             })
        ],
      ),
    );
  }

  Widget buildUserService(ServiceModel model){
    return Container(
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
                  style:const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,

                  ),
                ),
                Text(
                  'Car Number : ${model.carNumber}',
                  style:const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,

                  ),
                ),
                Text(
                  'Services is : ${model.services}',
                  style:const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,

                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

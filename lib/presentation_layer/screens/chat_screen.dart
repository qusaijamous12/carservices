import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/state.dart';
import 'package:task_car_services/shared/utils/utils.dart';

import '../../data_layer/model/message_model.dart';

class ChatScreen extends StatelessWidget{
  // userModel ?usermodel;
  // DoctorModel ?doctorModel;
  // BookScreen ? bookScreen;
  var messageController=TextEditingController();
  final stationUid;
  final stationName;

  ChatScreen({required this.stationUid,required this.stationName});

  // ChatScreen({
  //   this.usermodel,
  //   this.doctorModel
  // });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        MapCubit.get(context).getMessages(context,receiverId: stationUid);
        return  BlocBuilder<MapCubit,MapState>(
            builder:(context,state){
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon:const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                      ),
                    ),
                    systemOverlayStyle:const SystemUiOverlayStyle(
                        statusBarColor: Colors.white,
                        statusBarIconBrightness: Brightness.dark
                    ),
                    title: Row(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     '${usermodel?.image}',
                        //   ),
                        //   radius: 30,
                        // ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          '${stationName}',
                          style:const TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                        )
                      ],
                    )
                ),
                body: ConditionalBuilder(
                  condition: true,
                  builder:(context)=>Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context,index){
                                var message=MapCubit.get(context).messages[index];
                                if(LoginCubit.get(context).uid==message.senderId)
                                  return BuildMyMessage(message);
                                return BuildMessage(message);

                              },
                              separatorBuilder: (context,index)=>const SizedBox(
                                height: 15,
                              ),
                              itemCount: MapCubit.get(context).messages.length),
                        ),
                        Container(
                          padding:const EdgeInsetsDirectional.only(
                              start: 7
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer ,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1

                              ),
                              borderRadius: BorderRadius.circular(15 )
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  //    DoctorCubit.get(context).openGalaryToSendImage();
                                },
                                child:const CircleAvatar(
                                  child: Icon(Icons.image
                                    ,
                                    color: Colors.grey,),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  decoration:const InputDecoration(
                                      hintText: 'type your message here...',
                                      border: InputBorder.none
                                  ),
                                ),

                              ),

                              Container(
                                color: Colors.blue[800],
                                height: 60,
                                width: 60,

                                child: IconButton(
                                    onPressed: (){
                                      MapCubit.get(context).sendMessage(context,
                                        receiverId:stationUid ,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                      messageController.text='';
                                      // print(usermodel!.name!);
                                      // Appointment.instance.sendPushNotification(usermodel!.token!);

                                    },
                                    icon:const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ) ,
                  fallback: (context)=>Center(child: CircularProgressIndicator()),
                ),


              );
            } );
      },
    );

  }
  Widget BuildMessage(MessageModel model)=> Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5
      ),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),



          )
      ),
      child: Text(
          '${model.text}'
      ),
    ),
  );
  Widget BuildMyMessage(MessageModel model)=>  Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5
      ),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),



          )
      ),
      child: Text(
          '${model.text}'
      ),
    ),
  );

}

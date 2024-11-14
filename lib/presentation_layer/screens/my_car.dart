
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/data_layer/model/service_model.dart';

import '../../shared/utils/utils.dart';
import 'home_screen.dart';

class MyCar extends StatefulWidget {
  const MyCar({super.key,required this.stationUid});
  final stationUid;


  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  List<ServiceModel> serviceModels = []; // Change to a list

  bool x=false;

  @override
  void initState() {
    FirebaseFirestore.instance.collection('users').doc(widget.stationUid).collection('services').get().then((value){
      value.docs.forEach((element){
        if(LoginCubit.get(context).uid==element['uid']){
          serviceModels.add(ServiceModel(
            element['car_number'],
            element['car_name'],
            element['services'],
            element['price'],
            element['uid'],
            element['percentage'],
          ));

           setState(() {

           });
        }
      });
      x=true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomeScreen(uid: '',)), (c)=>false);}, icon:const Icon(Icons.navigate_before,color: Colors.white,)),
        backgroundColor: Colors.blue[800],
        title:const Text('Car Details',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
      ),
      body: ConditionalBuilder(
          condition: x,
          builder: (context)=>Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context,index)=>buildMyCarItem(serviceModels[index]),
                      separatorBuilder: (context,index)=>const SizedBox(
                        height: 10,
                      ),
                      itemCount: serviceModels.length),
                )

              ],
            ),
          ),
          fallback: (context){
            if(serviceModels.length==0){
             return const Center(child:  Text('There is no cars for you !'));
            }
            else{
            return  const Center(child:  CircularProgressIndicator());
            }
          }),
    );
  }
}

class CirclePainter extends CustomPainter {
  final dynamic percentage;

  CirclePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    // Circle background
    Paint circleBackgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, circleBackgroundPaint);

    // Circle progress
    Paint circleProgressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    double angle = (percentage / 100) * 2 * 3.141592653589793; // Calculate the angle

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.141592653589793 / 2, // Start angle (top)
      angle, // Sweep angle
      false, // Use center
      circleProgressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint when percentage changes
  }
}
Widget buildMyCarItem(ServiceModel model)=> Card(
  color: Colors.white,
  elevation: 20,
  child: Expanded(
    child: Container(
      padding:const EdgeInsetsDirectional.all(kPadding),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUFlo2IjF3ZPjaZKxkjSKJPQ6ZAsA-62OB6g&s'),
                radius: 80,

              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(
            height: kPadding,
          ),
          Text(
            'Car Name: ${model.carName}',
            style:const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(
            height: kPadding/2,
          ),
          Text(
            'Services is :${model.services}',
            style:const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(
            height: kPadding/2,
          ),
          Text(
            'Price is ${model.price}\$',
            style:const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
            ),

          ),
          const SizedBox(
            height: kPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  CustomPaint(
                    size:const Size(100, 100), // Si
                    painter: CirclePainter(percentage:model.percenatge ),
                  ),
                  const SizedBox(
                    height: kPadding/4,
                  ),
                  Text(
                    '${model.percenatge} %',
                    style:const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ],
          )

        ],
      ),
    ),
  ),
);

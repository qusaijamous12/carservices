import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/presentation_layer/screens/chat_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_button.dart';
import 'package:task_car_services/presentation_layer/widgets/my_text_form_field.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';
import 'package:task_car_services/shared/utils/utils.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key,required this.carName,required this.services,required this.price,required this.carNumber,required this.uid,required this.percenatge});
  final String carName;
  final String carNumber;
  final dynamic price;
  final dynamic uid;
  final dynamic percenatge;
  final List<dynamic>services;

  @override
  State<CarDetails> createState() => _CarDetailsState();
}


class _CarDetailsState extends State<CarDetails> {
  @override
  dynamic ?percentage=0;
  var percentageController=TextEditingController();

  @override
  void initState() {
   percentage=widget.percenatge;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title:const Text('Car Details',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(stationUid: widget.uid, stationName: '11111')));
          },
              icon:const Icon(Icons.chat,color: Colors.white,))
        ],
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsetsDirectional.all(kPadding),
        child: Column(
          children: [
            Card(
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
                        'Car Name: ${widget.carName}',
                        overflow: TextOverflow.ellipsis,
                        style:const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(
                        height: kPadding/2,
                      ),
                      Text(
                        'Services is :${widget.services}}',
                        overflow: TextOverflow.ellipsis,

                        style:const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(
                        height: kPadding/2,
                      ),
                      Text(
                        'Price is ${widget.price} \$',
                        overflow: TextOverflow.ellipsis,

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
                                painter: CirclePainter(percentage:percentage),
                              ),
                             const SizedBox(
                                height: kPadding/4,
                              ),
                                Text(
                                '${percentage} %',
                                  overflow: TextOverflow.ellipsis,

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
            ),
          const  SizedBox(
              height: kPadding*2,
            ),
            MyTextFormField(textController:percentageController , hintText: 'Enter Percentage', prefixIcon:const Icon(Icons.percent), keyBoardType: TextInputType.number),
            const  SizedBox(
              height: kPadding*2,
            ),
            MyButton(title: 'Update', onPress: (){
              percentage=double.parse(percentageController.text);
              setState(() {

              });
              FirebaseFirestore.instance.collection('users').doc(LoginCubit.get(context).uid).collection('services').get().then((value){
                value.docs.forEach((element){
                  if(element['car_number']==widget.carNumber){
                    DocumentReference documentReference = element.reference;
                   
                    documentReference.update({'percentage':percentage}).then((value){
                      MyToast.showToast(title: 'UpdatedSuccess!');
                      percentageController.text='';
                    }).catchError((error){
                      print('Updated Error !');
                    });
                    
                  }

                });

              });

            })

          ],
        ),
      ),
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


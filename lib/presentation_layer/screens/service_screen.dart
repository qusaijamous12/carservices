import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_car_services/presentation_layer/screens/home_screen.dart';
import 'package:task_car_services/presentation_layer/widgets/my_button.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';

import '../../shared/utils/utils.dart';
import '../widgets/my_text_form_field.dart';
import 'map_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key,required this.staionName,required this.uid});
  final String ?staionName;
  final String uid;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final carNameController=TextEditingController();
  final carNumberController=TextEditingController();
  List<bool> aymanStaion=List.generate(7, (index) => false);




  List<String> services=[];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: SingleChildScrollView(
          physics:const BouncingScrollPhysics(),
          padding:const EdgeInsetsDirectional.all(kPadding),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome in ${widget.staionName} Station',style:const TextStyle(color:Colors.blue,fontSize: 40,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: kPadding,
              ),
                const  Text(
                  'Oil Change:',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                buildCheckBoxList(title: 'Engine Lubrication', value: aymanStaion[0],onChanged: (value){
                  aymanStaion[0]=!aymanStaion[0];
                  togleServices(serviceName: 'Engine Lubrication', isSelected: aymanStaion[0]);
                  setState(() {

                  });

                }),
                buildCheckBoxList(title: 'Filter Replacement', value: aymanStaion[1],onChanged: (value){
                  aymanStaion[1]=!aymanStaion[1];
                  togleServices(serviceName: 'Filter Replacement', isSelected: aymanStaion[1]);
                  setState(() {

                  });
                }),
                buildCheckBoxList(title: 'Oil Type', value: aymanStaion[2],onChanged: (value){
                  aymanStaion[2]=!aymanStaion[2];
                  togleServices(serviceName: 'Oil Type', isSelected: aymanStaion[2]);

                  setState(() {

                  });
                }),
                buildCheckBoxList(title: 'Regular Maintenance', value: aymanStaion[3],onChanged: (value){
                  aymanStaion[3]=!aymanStaion[3];
                  togleServices(serviceName: 'Regular Maintenance', isSelected: aymanStaion[3]);

                  setState(() {

                  });
                }),
                const  Text(
                  'Tire Rotation:',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                buildCheckBoxList(title: 'Tire Wear Evenly', value: aymanStaion[4],onChanged: (value){
                  aymanStaion[4]=!aymanStaion[4];
                  togleServices(serviceName: 'Tire Wear Evenly', isSelected: aymanStaion[4]);


                  setState(() {

                  });
                }),
                buildCheckBoxList(title: 'Extended Tire Life', value: aymanStaion[5],onChanged: (value){
                  aymanStaion[5]=!aymanStaion[5];
                  togleServices(serviceName: 'Extended Tire Life', isSelected: aymanStaion[5]);

                  setState(() {

                  });
                }),
                buildCheckBoxList(title: 'Improved Traction and Handling', value: aymanStaion[6],onChanged: (value){
                  aymanStaion[6]=!aymanStaion[6];
                  togleServices(serviceName: 'Improved Traction and Handling', isSelected: aymanStaion[6]);

                  setState(() {

                  });
                }),
                const SizedBox(
                  height: kPadding*2,
                ),

              MyTextFormField(textController: carNameController, hintText: 'Car Name', prefixIcon:const Icon(Icons.drive_file_rename_outline), keyBoardType: TextInputType.text),
              const SizedBox(
                height: kPadding,
              ),
              MyTextFormField(textController: carNumberController, hintText: 'Car Number', prefixIcon:const Icon(Icons.numbers), keyBoardType: TextInputType.number),
              const SizedBox(
                height: kPadding,
              ),
              MyButton(title: 'Send', onPress: (){
                if(carNameController.text.isNotEmpty&&carNumberController.text.isNotEmpty){
                  if(aymanStaion.any((value)=>value==true)){
                    print('qqqq');
                    FirebaseFirestore.instance.collection('users').doc(widget.uid).collection('services').add({
                      'car_name':carNameController.text,
                      'car_number':carNumberController.text,
                      'services':services
                    }).
                    then((value){
                      MyToast.showToast(title: 'Send Success');
                      carNameController.text='';
                      carNumberController.text='';
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomeScreen()), (x)=>false);

                    }).
                    catchError((error){

                      MyToast.showToast(title: 'There is an error');
                    });

                  }

                }
              })












            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckBoxList({required String title,required bool value,required void Function(bool?)? onChanged})=>  Padding(
    padding: const EdgeInsets.only(bottom: kPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            value:value ,
            onChanged: onChanged),
        const SizedBox(
          width: kPadding,
        ),
        Text(
            '$title',
            style:const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500
            )

        )

      ],
    ),
  );

  void togleServices({required String serviceName,required bool isSelected}){
    if(isSelected){
      services.add(serviceName);
    }
    else{
      services.remove(serviceName);
    }
  }

  void sendServices({required List<bool> stationName , required List<String> services,}){

    print('the services is $services');

    MyToast.showToast(title: 'Send Success');

    carNameController.text='';

    carNumberController.text='';

    stationName=List.generate(7, (index) => false);
    services=[];
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MapScreen()), (route) => false);

  }

}

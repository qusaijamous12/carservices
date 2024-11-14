import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/presentation_layer/widgets/my_button.dart';
import 'package:task_car_services/presentation_layer/widgets/my_text_form_field.dart';
import 'package:task_car_services/presentation_layer/widgets/my_toast.dart';

class AddMyCars extends StatelessWidget {
  const AddMyCars({super.key});

  @override
  Widget build(BuildContext context) {
    final carNameController=TextEditingController();
    final carNumberController=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_outlined),color: Colors.white,),
        title:const Text(
          'My Cars',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add your cars data ',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 30
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(textController:carNameController , hintText: 'Car Name', prefixIcon:const Icon(Icons.drive_file_rename_outline), keyBoardType: TextInputType.text),
            const SizedBox(
              height: 10,
            ),
            MyTextFormField(textController:carNumberController , hintText: 'Car Number', prefixIcon:const Icon(Icons.numbers), keyBoardType: TextInputType.text),
            const SizedBox(
              height: 40,
            ),
            MyButton(title: 'Add', onPress: (){
             final result= MapCubit.get(context).addMyCarsFireStore(context, carName: carNameController.text, carNumber: carNumberController.text);
             if(result){
               carNameController.text='';
               carNumberController.text='';
               MyToast.showToast(title: 'Add Success');
             }
             else{
               MyToast.showToast(title: 'There is an error ');
             }

            })



          ],
        ),
      ),
    );
  }
}

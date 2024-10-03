import 'package:flutter/material.dart';
import 'package:task_car_services/shared/utils/utils.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,required this.textController,required this.hintText,required this.prefixIcon,required this.keyBoardType});
  final textController;
  final hintText;
  final prefixIcon;
  final keyBoardType;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {


  @override
  Widget build(BuildContext context) {
    return Container(


      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadiusDirectional.circular(kPadding)
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
        decoration:InputDecoration(
          border: InputBorder.none,
          labelText: '${widget.hintText}',
          prefixIcon:widget.prefixIcon,

        ),
        controller:widget.textController,
        keyboardType: widget.keyBoardType,


      ),

    );
  }
}

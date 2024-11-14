import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_car_services/buisness_logic_layer/login_bloc/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/cubit.dart';
import 'package:task_car_services/buisness_logic_layer/map_cubit/state.dart';
import 'package:task_car_services/data_layer/model/my_cars_model.dart';
import 'package:task_car_services/presentation_layer/screens/chat_screen.dart';
import 'package:task_car_services/presentation_layer/screens/home_screen.dart';
import 'package:task_car_services/presentation_layer/screens/my_car.dart';
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

  List<MyCarsModel> myCars = [];
  MyCarsModel? selectedCar;

  List<bool> aymanStaion=List.generate(7, (index) => false);
  double sum=0;

  List<String> services=[];

  @override
  void initState() {
    MapCubit.get(context).getMyCars(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomeScreen(uid: '',)), (c)=>false);}, icon:const Icon(Icons.navigate_before,color: Colors.white,)),
        title:const Text('Services Screen',style:TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(stationUid: widget.uid,stationName: widget.staionName,)));
              },
              icon:const Icon(Icons.chat,color: Colors.white,))
        ],
      ),
      body:BlocBuilder<MapCubit,MapState>(builder: (context,state){

        return ConditionalBuilder(
            condition: state is ! LoadingGetMyCarsState,
            builder: (context)=>SafeArea(
              child: SingleChildScrollView(
                physics:const BouncingScrollPhysics(),
                padding:const EdgeInsetsDirectional.all(kPadding),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome in ${widget.staionName} Station',style: TextStyle(color:Colors.blue[800],fontSize: 40,fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      'Oil Change:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    buildCheckBoxList(title: 'Engine Lubrication', value: aymanStaion[0],onChanged: (value){
                      aymanStaion[0]=!aymanStaion[0];
                      togleServices(serviceName: 'Engine Lubrication', isSelected: aymanStaion[0],summ: 7.00);
                      setState(() {

                      });

                    },price: 7.00),
                    buildCheckBoxList(title: 'Filter Replacement', value: aymanStaion[1],onChanged: (value){
                      aymanStaion[1]=!aymanStaion[1];
                      togleServices(serviceName: 'Filter Replacement', isSelected: aymanStaion[1],summ: 5.00);
                      setState(() {

                      });
                    },price: 5.00),
                    buildCheckBoxList(title: 'Oil Type', value: aymanStaion[2],onChanged: (value){
                      aymanStaion[2]=!aymanStaion[2];
                      togleServices(serviceName: 'Oil Type', isSelected: aymanStaion[2],summ: 20.00);

                      setState(() {

                      });
                    },price: 20.00),
                    buildCheckBoxList(title: 'Regular Maintenance', value: aymanStaion[3],onChanged: (value){
                      aymanStaion[3]=!aymanStaion[3];
                      togleServices(serviceName: 'Regular Maintenance', isSelected: aymanStaion[3],summ: 25.00);

                      setState(() {

                      });
                    },price: 25.00),
                    Text(
                      'Tire Rotation:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    buildCheckBoxList(title: 'Tire Wear Evenly', value: aymanStaion[4],onChanged: (value){
                      aymanStaion[4]=!aymanStaion[4];
                      togleServices(serviceName: 'Tire Wear Evenly', isSelected: aymanStaion[4],summ: 26.00);


                      setState(() {

                      });
                    },price: 26.00),
                    buildCheckBoxList(title: 'Extended Tire Life', value: aymanStaion[5],onChanged: (value){
                      aymanStaion[5]=!aymanStaion[5];
                      togleServices(serviceName: 'Extended Tire Life', isSelected: aymanStaion[5],summ: 22.00);

                      setState(() {

                      });
                    },price: 22.00),
                    buildCheckBoxList(title: 'Improved Traction and Handling', value: aymanStaion[6],onChanged: (value){
                      aymanStaion[6]=!aymanStaion[6];
                      togleServices(serviceName: 'Improved Traction and Handling', isSelected: aymanStaion[6],summ: 18.00);

                      setState(() {

                      });
                    },price: 18.00),
                    const SizedBox(
                      height: kPadding,
                    ),

                    BlocBuilder<MapCubit, MapState>(
                      builder: (context, state) {
                        return ConditionalBuilder(
                          condition: MapCubit.get(context).myCars.isNotEmpty,
                          builder: (context) => Container(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildMyCarList(MapCubit.get(context).myCars[index], (car) {
                                    setState(() {
                                      selectedCar = car; // Update selected car
                                    });
                                  }),
                              separatorBuilder: (context, index) => const SizedBox(
                                width: 10,
                              ),
                              itemCount: MapCubit.get(context).myCars.length,
                            ),
                          ),
                          fallback: (context) => const Center(child: Text('You have to add a car')),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Display selected car info
                    if (selectedCar != null) ...[
                      Text('Selected Car is: ${selectedCar!.carName}, ${selectedCar!.carNumber}',style:const TextStyle(color:Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: kPadding),
                    ],

                    const SizedBox(
                      height: kPadding*2,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: MyButton(title: 'Send', onPress: (){
                            if(selectedCar!=null) {
                              if (aymanStaion.any((value) => value == true)) {
                                FirebaseFirestore.instance.collection('users')
                                    .doc(widget.uid).collection('services').add(
                                    {
                                      'car_name': selectedCar!.carName,
                                      'car_number': selectedCar!.carNumber,
                                      'services': services,
                                      'price': sum,
                                      'uid': LoginCubit
                                          .get(context)
                                          .uid,
                                      'percentage': 0
                                    })
                                    .
                                then((value) {
                                  showDialog(
                                      context: context, builder: (context) =>
                                      AlertDialog(
                                        title: Text(
                                          'Station name:${widget.staionName}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),),
                                        content: Text(
                                          'Services is send Success Price is $sum',
                                          style: const TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.w500),),
                                      )).then((value) {
                                    carNumberController.text = '';
                                    carNameController.text = '';
                                    Future.delayed(
                                        const Duration(microseconds: 1000))
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(uid: '',)), (
                                              c) => false);
                                      //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyCar(carName: carNameController.text, services: services, price: sum, carNumber: carNumberController.text)), (c)=>false);

                                    });
                                  });
                                }).
                                catchError((error) {
                                  MyToast.showToast(title: 'There is an error');
                                });
                              }
                              else{
                                MyToast.showToast(title: 'You have to chose service');


                              }
                            }
                            else{
                              MyToast.showToast(title: 'You have to select a car and chose services');
                            }
                          }),
                        ),
                        const SizedBox(width: kPadding/4,),
                        Expanded(child: MyButton(title: 'MyCars', onPress: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCar(stationUid: widget.uid)));

                        }))
                      ],
                    )
                  ],
                ),
              ),
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator()));

      }),
    );
  }

  Widget buildCheckBoxList({required String title,required bool value,required void Function(bool?)? onChanged,required double price})=>  Padding(
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
        Expanded(
          child: Text(
              '$title',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              )
          
          ),
        ),
        Text('$price\$',style:const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,

        ),)


      ],
    ),
  );

  void togleServices({required String serviceName,required bool isSelected,required double summ}){
    if(isSelected){
      services.add(serviceName);
      sum+=summ;
    }
    else{
      services.remove(serviceName);
      sum-=summ;
    }
  }

  void sendServices({required List<bool> stationName , required List<String> services,}){

    print('the services is $services');

    MyToast.showToast(title: 'Send Success');

    carNameController.text='';

    carNumberController.text='';

    stationName=List.generate(7, (index) => false);
    services=[];
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MapScreen()));

  }

  Widget buildMyCarList(MyCarsModel car, Function(MyCarsModel) onSelect) => GestureDetector(
    onTap: () => onSelect(car),
    child: Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadiusDirectional.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUFlo2IjF3ZPjaZKxkjSKJPQ6ZAsA-62OB6g&s',
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            'Car name: ${car.carName}',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          Text(
            'Car number: ${car.carNumber}',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );

}

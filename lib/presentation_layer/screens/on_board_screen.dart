import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_car_services/presentation_layer/screens/login_screen.dart';
import 'package:task_car_services/shared/utils/utils.dart';

class OnBoardingScreen extends StatefulWidget{
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoard> item=[
    OnBoard(
        image: 'assets/images/carone.png'
        , title: 'Discover the essential features for maintaining your car.'),
    OnBoard(
        image: 'assets/images/cartwo.png'
        , title: 'Receive alerts and advice to ensure optimal performance.'),
  ];

  bool isLast=false;

  final BoardingController=PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle:const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,

          ),
        ),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index){
                    if(index==item.length-1){
                      setState(() {
                        isLast=true;
                      });
                    }
                    else
                    {
                      setState(() {
                        isLast=false;
                      });

                    }
                  },
                  controller: BoardingController,
                  itemBuilder: (context,index)=>buildPageViewItem(item[index],context),
                  itemCount: 2,
                ),
              ),
             const SizedBox(
                height: 20,
              ),
              Padding(
                padding:const EdgeInsetsDirectional.only(
                    bottom: kPadding
                ),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: BoardingController,
                      count: 2,
                      effect: ExpandingDotsEffect(
                          dotColor: Colors.grey.shade200,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                          activeDotColor: Colors.blue.shade800

                      ),
                    ),
                   const Spacer(),
                    FloatingActionButton(
                      backgroundColor: Colors.blue[800],
                      onPressed: (){

                        if(isLast){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (route) => false);

                        }
                        else {
                          BoardingController.nextPage(
                              duration:const Duration(
                                  milliseconds: 750
                              )
                              , curve: Curves.fastEaseInToSlowEaseOut);
                        }
                      },
                      child:const Icon(
                          Icons.navigate_next,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
  Widget buildPageViewItem(OnBoard board,context)=> Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
            image: AssetImage(
                '${board.image}'
            )),
      ),
      Text(
          '${board.title}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.black
          )
      ),

    ],
  );
}
class OnBoard{
  var image;
  var title;
  OnBoard({
    required String image,
    required String title
  }){
    this.image=image;
    this.title=title;

  }



}
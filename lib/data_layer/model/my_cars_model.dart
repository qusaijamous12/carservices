class MyCarsModel{
  String ?carName;
  String ?carNumber;

  MyCarsModel({this.carName,this.carNumber});

  MyCarsModel.fromJson(Map<String,dynamic> json){
    carName=json['car_name'];
    carNumber=json['car_number'];

  }


}
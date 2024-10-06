class ServiceModel{

  String ?carName;
  String ?carNumber;
  dynamic ?price;
  dynamic uid;
  List<dynamic> ?services;
  dynamic percenatge;

  ServiceModel(this.carNumber,this.carName,this.services,this.price,this.uid,this.percenatge);

  ServiceModel.fromJson(Map<String,dynamic> json){
    carName=json['car_name'];
    carNumber=json['car_number'];
    services=json['services'];
    price=json['price'];
    uid=json['uid'];
    percenatge=json['percentage'];
  }

}
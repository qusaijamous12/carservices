class ServiceModel{

  String ?carName;
  String ?carNumber;
  List<String> ?services;

  ServiceModel(this.carNumber,this.carName,this.services);

  ServiceModel.fromJson(Map<String,dynamic> json){
    carName=json['car_name'];
    carNumber=json['car_number'];
    services=json['services'];
  }

}
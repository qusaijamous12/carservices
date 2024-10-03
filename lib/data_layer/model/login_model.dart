class LoginModel{

  String ?userName;
  String ?email;
  int ?status;
  String ?phoneNumber;
  double ?latitude;
  double ?longtitue;
  String ?uid;

  LoginModel(this.userName,this.email,this.status,this.latitude,this.longtitue,this.phoneNumber,this.uid);

  LoginModel.fromJson(Map<String,dynamic> json){

    userName=json['user_name'];
    email=json['email'];
    status=json['status'];
    uid=json['uid'];
    latitude=json['lattiude'];
    longtitue=json['longtitude'];
    phoneNumber=json['phone_number'];
  }

}
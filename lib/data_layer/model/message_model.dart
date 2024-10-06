class MessageModel {
  late final DateTime ?createdAt;
  String ?senderId;
  String ?reciverId;
  String ?dateTime;
  String ?text;



  MessageModel({
    this.createdAt,
    this.senderId,
    this.reciverId,
    this.dateTime,
    this.text,

  });
  MessageModel.fromJson(Map<String,dynamic> json)
  {
    senderId=json['senderId'];
    createdAt=json['createdAt'];
    reciverId=json['reciverId'];
    dateTime=json['dateTime'];
    text=json['text'];

  }
  Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'createdAt':createdAt,
      'reciverId':reciverId,
      'dateTime':dateTime,
      'text':text,





    };
  }

}
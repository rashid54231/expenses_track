class NotificationModel {

  final String id;
  final String title;
  final String message;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "title": title,
      "message": message,
      "date": date.toIso8601String(),
    };
  }

}
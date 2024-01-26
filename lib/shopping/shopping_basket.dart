import 'dart:convert';

class ShoppingBasket{
  String id;
  String title;
  bool isDone;
  List<String> items;
  DateTime? dateTime;
  String? imagePath;
  String? voiceRecordPath;
  String? lng;
  String? lat;
  String? locationDescription;

  ShoppingBasket(this.id, this.title, this.isDone, this.items, {this.dateTime, this.imagePath, this.voiceRecordPath, this.lat, this.lng, this.locationDescription});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'isDone': isDone,
      'items': jsonEncode(items),
      'dateTime': dateTime?.toIso8601String(),
      'imagePath': imagePath,
      'voiceRecordPath': voiceRecordPath,
      'lng': lng,
      'lat': lat,
      'locationDescription': locationDescription,
    };
  }

  factory ShoppingBasket.fromMap(Map<String, dynamic> map) {
    return ShoppingBasket(
      map['id'],
      map['title'],
      map['isDone'] == 0 ? true : false,
      jsonDecode(map['items']).cast<String>(),
      dateTime: DateTime.parse(map['dateTime']),
      imagePath: map['imagePath'],
      voiceRecordPath: map['voiceRecordPath'],
      lng: map['lng'],
      lat: map['lat'],
      locationDescription: map['locationDescription'],
    );
  }
}
class ShoppingBasket{
  String id;
  String title;
  List<String> items;
  String? imagePath;
  String? voiceRecordPath;

  ShoppingBasket(this.id, this.title, this.items, {this.imagePath, this.voiceRecordPath});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'items': items,
      'imagePath': imagePath,
      'voiceRecordPath': voiceRecordPath
    };
  }
}
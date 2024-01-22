import 'package:flutter/material.dart';

class AddShoppingBasket extends StatefulWidget{
  @override
  _AddShoppingBasketState createState()=>_AddShoppingBasketState();
}

class _AddShoppingBasketState extends State<AddShoppingBasket>{
  final TextEditingController _textTitleFieldController = TextEditingController();
  final TextEditingController _textDescriptionFieldController = TextEditingController();
  // File? _image;
  // final imagePicker = ImagePicker();
  //
  // void getImageFromGallery() async {
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping Basket'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textTitleFieldController,
                decoration: const InputDecoration(hintText: 'Shopping basket title'),
              ),
              TextField(
                controller: _textDescriptionFieldController,
                decoration:
                const InputDecoration(hintText: 'Enter todo description here'),
              ),
              TextButton(
                onPressed: () {
                  _addShoppingBasket(context);
                },
                child: const Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<String> saveImageToFileSystem(File imageFile) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final fileName = basename(imageFile.path);
  //   final savedImage = await imageFile.copy('${directory.path}/$fileName');
  //   return savedImage.path;
  // }

  Future<void> _addShoppingBasket(BuildContext context) async {
    String title = _textTitleFieldController.text;
    // String description = _textDescriptionFieldController.text;
    String? imagePath;
    String id = DateTime.now().toIso8601String();

    // if(_image != null){
    //   imagePath = await saveImageToFileSystem(_image!);
    // }

    // Todo todo = Todo(id, title, false, description, imagePath: imagePath);

    // Navigator.pop(context, todo);

  }

}
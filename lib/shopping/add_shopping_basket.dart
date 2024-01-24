import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class AddShoppingBasket extends StatefulWidget{
  @override
  _AddShoppingBasketState createState()=>_AddShoppingBasketState();
}

class _AddShoppingBasketState extends State<AddShoppingBasket>{
  final TextEditingController _textTitleFieldController = TextEditingController();
  final TextEditingController _textDescriptionFieldController = TextEditingController();
  TextEditingController textPlaceFieldController = TextEditingController();
  late double lng;
  late double lat;

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
              SizedBox(height: 20),
              placesAutoCompleteTextField(),
              TextButton(
                onPressed: () {
                  _addShoppingBasket(context);
                },
                child: const Text('Add'),
              ),
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

  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: textPlaceFieldController,
        googleAPIKey:"AIzaSyASUEvfB48BeoYiKNS4BISIa52VRiRzBVc",
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["fi"],
        isLatLngRequired: false,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
        },

        itemClick: (Prediction prediction) {
          textPlaceFieldController.text = prediction.description ?? "";
          lng = double.parse(prediction.lng!);
          lat = double.parse(prediction.lat!);
          textPlaceFieldController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description??""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}
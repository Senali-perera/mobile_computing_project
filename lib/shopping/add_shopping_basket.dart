import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';

import '../map/map_view.dart';

class AddShoppingBasket extends StatefulWidget {
  @override
  _AddShoppingBasketState createState() => _AddShoppingBasketState();
}

class _AddShoppingBasketState extends State<AddShoppingBasket> {
  String apiKey = "AIzaSyASUEvfB48BeoYiKNS4BISIa52VRiRzBVc";
  final TextEditingController _textTitleFieldController =
      TextEditingController();
  final TextEditingController _textDescriptionFieldController =
      TextEditingController();
  TextEditingController textPlaceFieldController = TextEditingController();
  double? lng;
  double? lat;

  File? _image;
  final imagePicker = ImagePicker();

  void getImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.purple[300],
    minimumSize: Size(400, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping Basket'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textTitleFieldController,
                decoration:
                    const InputDecoration(hintText: 'Shopping basket title'),
              ),
              TextField(
                controller: _textDescriptionFieldController,
                decoration: const InputDecoration(
                    hintText: 'Enter todo description here'),
              ),
              SizedBox(height: 20),
              placesAutoCompleteTextField(),
              lng != null
                  ? TextButton(
                      onPressed: () {
                        _goToMap(context);
                      },
                      child: const Text('Go to the map'),
                    )
                  : const Column(),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  getImageFromGallery();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue, width: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Add Picture",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: _image != null ? Image.file(_image!) : const Column()),
              const Expanded(
                child: SizedBox(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    _addShoppingBasket(context);
                  },
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToMap(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapView(
              lat: lat ?? 0.0,
              lng: lng ?? 0.0,
              description: _textDescriptionFieldController.text),
        ));
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
        googleAPIKey: apiKey,
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["fi"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          setState(() {
            lng = double.parse(prediction.lng.toString());
            lat = double.parse(prediction.lat.toString());
          });
        },

        itemClick: (Prediction prediction) {
          textPlaceFieldController.text = prediction.description ?? "";
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
                Expanded(child: Text("${prediction.description ?? ""}"))
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

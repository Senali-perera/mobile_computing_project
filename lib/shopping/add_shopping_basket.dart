import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_computing_project/shopping/shopping_basket.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import '../map/map_view.dart';

class AddShoppingBasket extends StatefulWidget {
  @override
  _AddShoppingBasketState createState() => _AddShoppingBasketState();
}

class _AddShoppingBasketState extends State<AddShoppingBasket> {
  String apiKey = "";
  final TextEditingController _textTitleFieldController =
      TextEditingController();
  final TextEditingController _textItemFieldController =
  TextEditingController();
  TextEditingController textPlaceFieldController = TextEditingController();
  double? lng;
  double? lat;
  File? _image;
  final imagePicker = ImagePicker();
  bool showPlayer = false;
  String? audioPath;
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  bool playing = false;
  late List<String> basketItems;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    basketItems = [];
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void capturePhoto() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> startRecording() async {
    audioRecord = AudioRecorder();

    if (await audioRecord.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/recording.m4a';

      await audioRecord.start(const RecordConfig(), path: filePath);
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    String? path = await audioRecord.stop();
    audioRecord.dispose();
    setState(() {
      // recoding_now=false;
      isRecording = false;
      audioPath = path!;
    });
  }

  Future<void> playRecording() async {
    playing = true;
    Source urlSource = UrlSource(audioPath!);
    await audioPlayer.play(urlSource);
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        playing = false;
        // setState(() {});
      }
    });
  }

  // final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  //   foregroundColor: Colors.black87,
  //   backgroundColor: Colors.purple[300],
  //   minimumSize: Size(400, 36),
  //   padding: EdgeInsets.symmetric(horizontal: 16),
  //   shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.all(Radius.circular(20)),
  //   ),
  // );

  void deleteShoppingItem(String item) {
    setState(() {
      basketItems.remove(item);
    });
  }

  void addItems(String item){
    setState(() {
      basketItems.add(item);
      _textItemFieldController.clear();
    });
  }

  Widget _viewShoppingItems(String shoppingItem) {
    return ListTile(
      title: Text(shoppingItem),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          deleteShoppingItem(shoppingItem);
        },
      ),
    );
  }

  void goToMap(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapView(
              lat: lat ?? 0.0,
              lng: lng ?? 0.0,
              description: textPlaceFieldController.text),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping Basket'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _addShoppingBasket(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textTitleFieldController,
                decoration:
                    const InputDecoration(hintText: 'Shopping basket title'),
              ),
              const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: placesAutoCompleteTextField(),
                ),
                IconButton.filled(
                  icon: Icon(Icons.map), // Example icon
                  onPressed: lng == null ? null : () => goToMap(context),
                )
              ],
            ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            capturePhoto();
                          },
                          child: const Text("Capture Photo")),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isRecording ? stopRecording() : startRecording();
                        },
                        child:
                            Text(isRecording ? "Stop Audio" : "Start Record"),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton.filled(
                          onPressed: audioPath == null ? null : playRecording,
                          icon: const Icon(Icons.play_arrow)),
                    ],
                  ),
                ],
              ),
              _image != null
                  ? SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: _image != null ? Image.file(_image!) : null)
                  : const Column(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textItemFieldController,
                      decoration: const InputDecoration(
                        hintText: 'Enter items',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      addItems(_textItemFieldController.text);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: basketItems.length,
                itemBuilder: (context, index) {
                  return _viewShoppingItems(basketItems[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImageToFileSystem(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  Future<void> _addShoppingBasket(BuildContext context) async {
    String title = _textTitleFieldController.text;
    String locationDescription = textPlaceFieldController.text;
    String? imagePath;
    String id = DateTime.now().toIso8601String();
    DateTime dateTime = DateTime.now();

    if(_image != null){
      imagePath = await saveImageToFileSystem(_image!);
    }

    ShoppingBasket shoppingBasket = ShoppingBasket(id, title, false, basketItems, dateTime:dateTime, imagePath: imagePath, voiceRecordPath: audioPath, lat: lat.toString(), lng: lng.toString(), locationDescription: locationDescription);

    Navigator.pop(context, shoppingBasket);
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

        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }
}

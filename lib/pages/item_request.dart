import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

CollectionReference lost = FirebaseFirestore.instance.collection('Lost');
CollectionReference found = FirebaseFirestore.instance.collection('Found');
String _imgFromDeviceError = '';
Image? uploadedImg = null;
String uploadImgName = '';

const List<String> list = <String>[
  'Water Bottle',
  'ID',
  'Wallet',
  'Phone',
  'Coat',
  'Other'
];

final numberCheck =
    RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
final List<bool> isSelected = <bool>[true, false];
String description = "", category = "Water Bottle";
int phone = 0;
double lat = 0, long = 0;

const List<Widget> options = <Widget>[
  Text('Lost'),
  Text('Found'),
];

class ItemRequest extends StatefulWidget {
  ItemRequest({super.key, required this.itemLoc});
  final LatLng itemLoc;

  @override
  State<ItemRequest> createState() => _ItemRequestState();
}

class _ItemRequestState extends State<ItemRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    lat = widget.itemLoc.latitude;
    long = widget.itemLoc.longitude;

    return buildSubPage(
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Enter your item from: ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(("N: " + lat.toString() + " \nS: " + long.toString() + "\n"),
                style: TextStyle(
                  fontSize: 18,
                )),
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              children: options,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: DropdownButt(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: TextBox(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: PhoneNumber(),
            ),
            UploadImageButton(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ButtonTheme(
                minWidth: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isSelected[0]) {
                        addLost();
                      } else {
                        addFound();
                      }
                      routePage(const MapPage(), context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // move this somewhere else so we can use the same container style for all subpages?
  Widget buildSubPage(Widget body) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Container(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                      width: 3,
                      color: const Color.fromARGB(255, 221, 221, 221)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 122, 122, 122),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: body)),
      ),
    );
  }
}

Widget _buildErrMessage(AppTheme theme) => Text(_imgFromDeviceError,
    style: theme.regularStyle.copyWith(color: Colors.red),
    textAlign: TextAlign.center);
// all these classes im cringing help me i mean i guess its good to encapsulate but there's too much stuff in this file

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Description of Lost Item',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          description = value;
        }
        return null;
      },
    ));
  }
}

class PhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty || !numberCheck.hasMatch(value)) {
          return 'Please enter a valid phone number';
        } else {
          phone = int.parse(value.replaceAll('-', ''));
        }
        return null;
      },
    );
  }
}

class DropdownButt extends StatefulWidget {
  const DropdownButt({super.key});
  @override
  State<DropdownButt> createState() => _DropdownButtState();
}

class _DropdownButtState extends State<DropdownButt> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      alignment: Alignment.center,
      value: dropdownValue,
      borderRadius: BorderRadius.circular(14),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          category = dropdownValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({super.key});

  @override
  State<UploadImageButton> createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Upload Image"),
      onPressed: () {
        uploadImage();
      },
    );
  }

  uploadImage() async {
    // final ImagePicker _picker = ImagePicker();
    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    // print("Image Name: " + image!.name);
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List imgBytes = result.files.single.bytes!;
      String imgName = result.files.first.name;
      print("Image Name: " + imgName);
      setState(() {
        uploadedImg = Image.memory(imgBytes);
        uploadImgName = imgName;
      });
    } else {
      // User canceled the picker
      setState(() {
        _buildErrMessage(theme);
        uploadedImg = null;
      });
    }

    // final _firebaseStorage = FirebaseStorage.instance.ref();
    // String filePath = '';

    // File file;

    // if (kIsWeb) {
    //   var picked = await FilePicker.platform.pickFiles(type: FileType.image);

    //   if (picked != null) {
    //     file = File(picked.files.single.name);
    //     setState(() {
    //       var imageUrl = file;
    //     });
    //     try {
    //       await _firebaseStorage.putFile(file);
    //     } on Exception catch (_, e) {
    //       print("HI");
    //     }
    //   }
    // } else {
    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //   String filePath = '${appDocDir.absolute}';
    //   file = File(filePath);

    //   await _firebaseStorage.putFile(file);
    // }
  }
}

Future<void> addLost() {
  // Calling the collection to add a new user
  return lost
      //adding to firebase collection
      .add({
    //Data added in the form of a dictionary into the document.
    'Description': description,
    'ItemName': category,
    'Location': GeoPoint(lat, long),
    'Phone': phone,
    'Picture': 0
  });
}

Future<void> addFound() {
  // Calling the collection to add a new user
  return found
      //adding to firebase collection
      .add({
    //Data added in the form of a dictionary into the document.
    'Description': description,
    'ItemName': category,
    'Location': GeoPoint(lat, long),
    'Phone': phone,
    'Picture': 0
  });
}

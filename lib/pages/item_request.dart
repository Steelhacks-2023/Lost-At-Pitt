import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  String title = '';
  //String _error = '';

  Widget _buildErrMessage(AppTheme theme) => Text(_imgFromDeviceError,
      style: theme.regularStyle.copyWith(color: Colors.red),
      textAlign: TextAlign.center);

  Widget _buildTitleTF(AppTheme theme) {
    return SizedBox(
        child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Description of Lost Item',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => setState(() {
        title = value;
      }),
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

  Widget _buildPhoneNumTF(AppTheme theme) {
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

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    lat = widget.itemLoc.latitude;
    long = widget.itemLoc.longitude;

    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    child: Form(
                      key: _formKey,
                      child: Scaffold(
                          backgroundColor: Color.fromARGB(255, 233, 227, 206),
                          body: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Stack(children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Enter your item from: ',
                                        style: theme.titleStyle),
                                    SizedBox(height: 10),
                                    Text("N: $lat\nS: $long\n",
                                        style: theme.subtitleStyle),
                                    ToggleButtons(
                                      isSelected: isSelected,
                                      onPressed: (int index) {
                                        setState(() {
                                          //weird math to set selected index to true and other to false
                                          if (isSelected[(2 - index) % 2]) {
                                            isSelected[(2 - index + 1) % 2] =
                                                false;
                                          } else {
                                            isSelected[(2 - index) % 2] = true;
                                            isSelected[(2 - index + 1) % 2] =
                                                false;
                                          }
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.green.shade800,
                                      children: options,
                                    ),
                                    SizedBox(height: 10),
                                    DropdownButt(),
                                    SizedBox(height: 10),
                                    _buildTitleTF(theme),
                                    SizedBox(height: 10),
                                    _buildPhoneNumTF(theme),
                                    SizedBox(height: 10),
                                    UploadImageButton(),
                                    SizedBox(height: 10.0),
                                    ButtonTheme(
                                      minWidth: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
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
                                    _buildErrMessage(theme),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const MapPage()));
                                        });
                                      },
                                    ))
                              ]))),
                    )))));
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
  late ImagePicker _picker;
  late Image? uploadedImg;

  Future uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      uploadedImg = Image.memory(imageData);
      setState(() {});
    }

    // print("Image Name: " + image!.name);

    // final AppTheme theme = Theme.of(context).extension<AppTheme>()!;

    // FilePickerResult? result =
    //     await FilePicker.platform.pickFiles(type: FileType.image);

    // if (result != null) {
    //   Uint8List imgBytes = result.files.single.bytes!;
    //   String imgName = result.files.first.name;
    //   print("Image Name: " + imgName);
    //   setState(() {
    //     uploadedImg = Image.memory(imgBytes);
    //     uploadImgName = imgName;
    //   });
    // } else {
    //   // User canceled the picker
    //   setState(() {
    //     _buildErrMessage(AppTheme());
    //     uploadedImg = null;
    //   });
    // }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();
    uploadedImg = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        child: Text("Upload Image"),
        onPressed: () {
          uploadImage();
        },
      ),
      SizedBox(height: 10),
      uploadedImg == null
          ? SizedBox()
          : SizedBox(
              width: 300,
              height: 300,
              child: uploadedImg,
            )
    ]);
  }
}

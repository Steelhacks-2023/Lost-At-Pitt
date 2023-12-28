import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_found_steelhacks/models/item.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/services/auth.dart';
import 'package:lost_found_steelhacks/services/data.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:image_picker/image_picker.dart';

Uint8List? imgBytesToFirebase;
String _imgName = '';

//currently getting sorted in build method but should probably just order it here
List<String> list = <String>[
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
  const ItemRequest({super.key, required this.itemLoc});
  final LatLng itemLoc;

  @override
  State<ItemRequest> createState() => _ItemRequestState();
}

class _ItemRequestState extends State<ItemRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _phoneNumController = TextEditingController();

  String title = '';
  String _error = '';
  bool loading = false;

  uploadImageToFirebase(String category) async {
    final storageRef = FirebaseStorage.instance.ref();

    final imageRef = storageRef.child("$category/$_imgName");
    try {
      await imageRef.putData(imgBytesToFirebase!);
      return true;
    } on FirebaseException {
      setState(() {
        _error = "Failed to upload to database. Please try again later.";
      });
      return false;
    }
  }

  Widget _buildErrMessage(AppTheme theme) => Text(_error,
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

  Future<void> addLost() async {
    Item item = Item(id: "", userId: AuthService.instance.user!.uid, timeCreated: Timestamp.now(), description: description, itemName: category, location: GeoPoint(lat, long),phone: phone, picture: _imgName);
    await FirebaseFirestore.instance.collection('lost').add(item.toFirestore());
  }

  Future<void> addFound() async {
    Item item = Item(id: "", userId: AuthService.instance.user!.uid, timeCreated: Timestamp.now(), description: description, itemName: category, location: GeoPoint(lat, long),phone: phone, picture: _imgName);
    await FirebaseFirestore.instance.collection('found').add(item.toFirestore());
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    lat = widget.itemLoc.latitude;
    long = widget.itemLoc.longitude;
    list.sort((a, b) => a.compareTo(b));
    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Container(
                    //border around form popup
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          color: const Color.fromARGB(255, 221, 221, 221)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Scaffold(
                          backgroundColor: const Color.fromARGB(255, 233, 227, 206),
                          body: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Stack(children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Enter your item from: ',
                                        style: theme.titleStyle),
                                    const SizedBox(height: 10),
                                    Text("N: $lat\nS: $long\n",
                                        style: theme.subtitleStyle),
                                    ToggleButtons(
                                      selectedBorderColor:
                                          Colors.green.shade900,
                                      selectedColor: Colors.white,
                                      fillColor: Colors.lightGreen.shade600,
                                      color: Colors.black,
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
                                      children: options,
                                    ),
                                    const SizedBox(height: 10),
                                    const DropdownButt(),
                                    const SizedBox(height: 10),
                                    _buildTitleTF(theme),
                                    const SizedBox(height: 10),
                                    _buildPhoneNumTF(theme),
                                    const SizedBox(height: 10),
                                    const UploadImageButton(),
                                    const SizedBox(height: 10.0),
                                    ButtonTheme(
                                      minWidth: 150,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green.shade800)),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (isSelected[0]) {
                                              if (await uploadImageToFirebase(
                                                  "lost")) {
                                                addLost();
                                              }
                                            } else {
                                              if (await uploadImageToFirebase(
                                                  "found")) {
                                                addFound();
                                              }
                                            }
                                            routeBack(context);
                                          } else {
                                            setState(() {
                                              _error =
                                                  "Form incorrect, please correct fields.";
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    _buildErrMessage(theme),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //isExpanded: true,
      alignment: Alignment.center,
      value: dropdownValue,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Color(0xFF2E7D32)),
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
      setState(() {
        imgBytesToFirebase = imageData;
        _imgName = image.path.split('/').last;
        //print("Image Name ${_imgName}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    uploadedImg = null;
    _imgName = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green.shade800)),
        child: const Text("Upload Image", style: TextStyle(color: Colors.white)),
        onPressed: () {
          uploadImage();
        },
      ),
      const SizedBox(height: 10),
      uploadedImg == null
          ? const SizedBox()
          : SizedBox(
              width: 150,
              height: 150,
              child: uploadedImg,
            )
    ]);
  }
}

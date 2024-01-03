import 'dart:typed_data';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/services/firestore_service.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';

Uint8List? bytes;
String imageName = '';
List<String> itemNameOptions = <String>[
  'Water Bottle',
  'ID',
  'Wallet',
  'Phone',
  'Coat',
  'Other'
];
String description = "";
String itemName = "";

class ItemRequest extends StatefulWidget {
  const ItemRequest({super.key, required this.itemLoc});
  final LatLng itemLoc;

  @override
  State<ItemRequest> createState() => _ItemRequestState();
}

class _ItemRequestState extends State<ItemRequest> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  bool buttonPressed = false;

  void setError(String msg) => setState(() => error = msg);
  void setButton(bool pressed) => setState(() => buttonPressed = pressed);

  uploadImageToFirebase(String category) async {
    final storageRef = FirebaseStorage.instance.ref();

    final imageRef = storageRef.child("$category/$imageName");
    try {
      await imageRef.putData(bytes!);
      return true;
    } on FirebaseException catch (e) {
      setState(() {
        error = "Failed to upload to database. Please try again later.";
      });
      return false;
    }
  }

  Widget buildDescription(AppTheme theme) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(Icons.question_mark),
          CupertinoTextFormFieldRow(
            initialValue: "Description",
            onChanged: (value) => setState(() {
              description = value;
            }),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else {
                description = value;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> addLost() {
    Item item = Item(
        id: "",
        userId: context.read<MyUser?>()!.uid,
        timeCreated: Timestamp.now(),
        description: description,
        itemName: itemName,
        location: GeoPoint(widget.itemLoc.latitude, widget.itemLoc.longitude),
        phone: 1,
        picture: imageName);
    // Calling the collection to add a new user
    return FirestoreService().addItemToFirestore(item, true);
  }

  Future<void> addFound() {
    Item item = Item(
        id: "",
        userId: context.read<MyUser?>()!.uid,
        timeCreated: Timestamp.now(),
        description: description,
        itemName: itemName,
        location: GeoPoint(widget.itemLoc.latitude, widget.itemLoc.longitude),
        phone: 1,
        picture: imageName);

    // Calling the collection to add a new user
    return FirestoreService().addItemToFirestore(item, false);
  }

  void submitItem() async {
    if (buttonPressed) {
      setState(() {
        error = "Form already submitted";
      });
    } else if (!formKey.currentState!.validate()) {
      setState(() {
        error = "Form incorrect, please correct fields.";
      });
    } else if (bytes == null) {
      setState(() {
        error = "Invalid or no image uploaded";
      });
    } else {
      setState(() {
        buttonPressed = true;
      });
      bool success = await FirestoreService.uploadImageToFirebase("${itemName}/${imageName}", bytes!);
      if (success) {
        await addFound();
      }
      routeBack(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    final BoxDecoration bodyDecoration = BoxDecoration(
      color: theme.veryLight,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
    itemNameOptions.sort((a, b) => a.compareTo(b));

    Widget buildError() => Text(error,
      style: theme.darkRegularStyle.copyWith(color: Colors.red),
      textAlign: TextAlign.center);

    return DefaultTextStyle(
        style: theme.lightRegularStyle,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 300),
                    decoration: bodyDecoration,
                    child: Scaffold(
                      body: Column(
                        children: [
                          FastForm(
                              inputDecorationTheme: InputDecorationTheme(
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: theme.medium, width: 3),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 3),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red[500]!, width: 2),
                                ),
                                filled: true,
                                fillColor: theme.light,
                              ),
                              formKey: formKey,
                              children: [
                                FastDropdown(
                                  initialValue: "Other",
                                  name: "item_name_dropdown",
                                  items: itemNameOptions,
                                  onChanged: (value) =>
                                      setState(() => itemName = value!),
                          
                                ),
                                FastTextField(
                                    name: "description_text_field",
                                    labelText: "Description",                              validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    } else {
                                      description = value;
                                    }
                                    return null;
                                  },),
                              ]),
                              UploadImageButton(),
                              IconButton(icon: Icon(Icons.add_box_rounded), onPressed: () => submitItem()),
                              buildError()
                        ],
                      ),
                          
                    )))));
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
        bytes = imageData;
        imageName = image.path.split('/').last;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    uploadedImg = null;
    imageName = '';
  }

  @override
  Widget build(BuildContext context) {
    return 
      TextButton.icon(
        icon: Icon(Icons.upload),
        label: Text("Upload image"),
        onPressed: () {
          uploadImage();
        },
      );
  }
}

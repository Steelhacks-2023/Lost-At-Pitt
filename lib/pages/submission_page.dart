// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
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
import 'package:provider/provider.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key, required this.itemLoc});
  final LatLng itemLoc;

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
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
  late ImagePicker _picker;
  late Image? uploadedImg;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    uploadedImg = null;
  }

  void setError(String msg) => setState(() => error = msg);

  uploadImageToFirebase(String category) async {
    final storageRef = FirebaseStorage.instance.ref();

    final imageRef = storageRef.child("$category/$imageName");
    try {
      await imageRef.putData(bytes!);
      return true;
    } on FirebaseException {
      setError("Failed to upload to database. Please try again later.");
      return false;
    }
  }

  Future loadImageIntoMemory() async {
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
    if (loading) {
      setError("Form already submitted");
    } else if (!formKey.currentState!.validate()) {
      setError("Please fill in form fields");
    } else if (bytes == null) {
      setError("Invalid or no image uploaded");
    } else {
      setState(() {
        loading = true;
        error = "";
      });
      bool success = await uploadImageToFirebase("$itemName/$imageName");
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

    Widget buildError() =>
        Text(error, style: theme.errorStyle, textAlign: TextAlign.center);

    Widget buildHeader() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Submit a found item", style: theme.darkTitleStyle),
            ),
            IconButton(
                color: theme.dark,
                icon: const Icon(Icons.close),
                onPressed: () => routeBack(context))
          ],
        );

    Widget buildForm() => FastForm(
            inputDecorationTheme: InputDecorationTheme(
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 3),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.medium, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.medium, width: 3),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.error, width: 3),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.error, width: 3),
              ),
              filled: true,
              fillColor: theme.light,
            ),
            formKey: formKey,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FastDropdown(
                  helperText: "Category",
                  name: "item_name_dropdown",
                  items: itemNameOptions,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    itemName = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FastTextField(
                  maxLines: 5,
                  helperText: "Description",
                  name: "description_text_field",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    description = value;
                    return null;
                  },
                ),
              ),
            ]);

    Widget buildUploadButton() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: theme.light,
                border: Border.all(color: theme.medium, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: TextButton.icon(
                icon: Icon(Icons.upload, color: theme.dark),
                label: Text(bytes == null ? "Upload image" : "Change image",
                    style: theme.darkSubtitleStyle),
                onPressed: () => loadImageIntoMemory()),
          ),
        );

    Widget buildUploadedImage() => uploadedImg != null
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    border: Border.all(color: theme.medium, width: 3)),
                child: uploadedImg!),
          )
        : const SizedBox(height: 1);

    Widget buildSubmitButton() => loading
        ? const Loading()
        : TextButton.icon(
            label: Text("Submit", style: theme.darkSubtitleStyle),
            icon: Icon(Icons.add_box_rounded, color: theme.dark),
            onPressed: () => submitItem());

    return DefaultTextStyle(
        style: theme.lightRegularStyle,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(
                        maxWidth: 500,
                        maxHeight: MediaQuery.of(context).size.height - 20),
                    decoration: bodyDecoration,
                    child: Scaffold(
                      body: Column(
                        children: [
                          buildHeader(),
                          buildForm(),
                          buildUploadButton(),
                          buildUploadedImage(),
                          const Spacer(),
                          buildSubmitButton(),
                          buildError()
                        ],
                      ),
                    )))));
  }
}

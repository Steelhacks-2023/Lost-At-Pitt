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

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Container(
          padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
                width: 3, color: const Color.fromARGB(255, 221, 221, 221)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 122, 122, 122),
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
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
                //child: DropdownButt(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                //child: TextBox(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                //child: PhoneNumber(),
              ),
              //UploadImageButton(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ButtonTheme(
                  minWidth: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isSelected[0]) {
                          //addLost();
                        } else {
                          //addFound();
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
        )));
  }
}

Widget _buildErrMessage(AppTheme theme) => Text(_imgFromDeviceError,
    style: theme.regularStyle.copyWith(color: Colors.red),
    textAlign: TextAlign.center);

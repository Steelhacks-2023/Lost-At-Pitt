import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_found_steelhacks/mapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

CollectionReference lost = FirebaseFirestore.instance.collection('Lost');
CollectionReference found = FirebaseFirestore.instance.collection('Found');


const List<String> list = <String>['Water Bottle', 'ID', 'Wallet', 'Phone', 'Coat', 'Other'];
final numberCheck = RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
final List<bool> isSelected = <bool>[true, false];
String description = "", category = "Water Bottle";
int phone = 0;
LatLng local = LatLng(0,0);
double lat = 0, long = 0;


const List<Widget> options = <Widget>[
  Text('Lost'),
  Text('Found'),
];
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const SwitchApp());
// }
void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(SwitchApp(coord: local));

}
class SwitchApp extends StatelessWidget {
  //const SwitchApp({super.key});
  const SwitchApp({Key? key, required this.coord}) : super(key: key);

  final LatLng coord;
  @override
  Widget build(BuildContext context) {
    lat = coord.latitude;
    long = coord.longitude;
    return  const MaterialApp(
      home: Scaffold(
        //appBar: AppBar(title: const Text('Switch Sample')),
        body: FormWidget(),
      ),
    );
  }
}


class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //SwitchExample(),
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
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
            // children: const <Widget>[
            //     Text('Lost'),
            //     Text('Found'),
            // ],
          ),
          DropdownButt(),
          TextBox(),
          PhoneNumber(),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  //this is where the form stuff is grabbed
                  print(category);
                  print(description);
                  print(phone);

                  if(isSelected[0]){
                    addLost();
                  }
                  else{
                    addFound();
                  }
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => const mapPage()));
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
            decoration: const InputDecoration(
              hintText: 'Description of Lost Item',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              else{
                description = value;
              }
              return null;
            },
    );
  }
}
class PhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your phone number',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty || !numberCheck.hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              else{
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
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
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
    );
  }
}
Future<void> addLost() {
      // Calling the collection to add a new user
      return lost
          //adding to firebase collection
          .add({
            //Data added in the form of a dictionary into the document.
              'Description':description, 
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
              'Description':description, 
              'ItemName': category,
              'Location': GeoPoint(lat, long),
              'Phone': phone,
              'Picture': 0
          });
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.teal.shade900),
        child: Center(
          child: SpinKitDoubleBounce(
            duration: Duration(seconds: 2),
            color: Colors.white,
          ),
        ));
  }
}
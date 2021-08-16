import 'package:flutter/material.dart';

class StudentsDetailedScreenAdmin extends StatefulWidget {
  static const String ScreenRoute = '/StudentsDetailedScreenAdmin';
  StudentsDetailedScreenAdmin({Key? key}) : super(key: key);

  @override
  StudentsDetailedScreenAdminState createState() =>
      StudentsDetailedScreenAdminState();
}

class StudentsDetailedScreenAdminState
    extends State<StudentsDetailedScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: Colors.black,
      ),
    );
  }
}

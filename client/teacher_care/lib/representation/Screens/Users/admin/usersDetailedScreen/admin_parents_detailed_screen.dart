import 'package:flutter/material.dart';

class ParentsDetailedScreenAdmin extends StatefulWidget {
  static const String ScreenRoute = '/ParentsDetailedScreenAdmin';
  ParentsDetailedScreenAdmin({Key? key}) : super(key: key);

  @override
  ParentsDetailedScreenAdminState createState() =>
      ParentsDetailedScreenAdminState();
}

class ParentsDetailedScreenAdminState
    extends State<ParentsDetailedScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: Colors.white,
      ),
    );
  }
}

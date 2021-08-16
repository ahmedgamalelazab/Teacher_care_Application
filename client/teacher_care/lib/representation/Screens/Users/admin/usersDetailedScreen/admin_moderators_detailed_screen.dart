import 'package:flutter/material.dart';

class ModeratorDetailedScreenAdmin extends StatefulWidget {
  static const String ScreenRoute = '/ModeratorDetailedScreenAdmin';
  ModeratorDetailedScreenAdmin({Key? key}) : super(key: key);

  @override
  _ModeratorDetailedScreenAdminState createState() =>
      _ModeratorDetailedScreenAdminState();
}

class _ModeratorDetailedScreenAdminState
    extends State<ModeratorDetailedScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: Colors.green,
      ),
    );
  }
}

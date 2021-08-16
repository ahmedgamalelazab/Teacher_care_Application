import 'package:flutter/material.dart';
import '../admin.dart';
import '../usersDetailedScreen/admin_teachers_detailed_screen.dart';

class AdminAddTeacherSuccessfullyAddedToSystem extends StatefulWidget {
  static const String ScreenRoute = '/AdminAddTeacherSuccessfullyAddedToSystem';
  AdminAddTeacherSuccessfullyAddedToSystem({Key? key}) : super(key: key);

  @override
  _AdminAddTeacherSuccessfullyAddedToSystemState createState() =>
      _AdminAddTeacherSuccessfullyAddedToSystemState();
}

class _AdminAddTeacherSuccessfullyAddedToSystemState
    extends State<AdminAddTeacherSuccessfullyAddedToSystem> {
  _navigateToAnotherScreenAfterPeriodOfTime(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _navigateToAnotherScreenAfterPeriodOfTime(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // successfully added pic
            Container(
              height: deviceHeight * 0.3,
              width: deviceHeight * 0.3,
              child: Image.asset('assets/images/success.png'),
            ),
            SizedBox(
              height: deviceHeight * 0.030,
            ),
            Container(
              child: Text(
                'successfully added Teacher to System',
              ),
            ),
            // say successfully added
          ],
        ),
      ),
    );
  }
}

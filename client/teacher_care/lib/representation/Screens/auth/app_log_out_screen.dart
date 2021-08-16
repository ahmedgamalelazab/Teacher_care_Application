import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ApplicationLogOutScreen extends StatelessWidget {
  static const ScreenRoute = './ApplicationLogOutScreen';
  const ApplicationLogOutScreen({Key? key}) : super(key: key);

  _killScreenAfterSeconds(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    _killScreenAfterSeconds(context);
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // log out picture and
            Container(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                color: Color(0xff283C63),
                indicatorType: Indicator.ballRotateChase,
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.080,
            ),
            Text(
              'Pleas Wait Logging you out',
              style: GoogleFonts.montserrat(
                fontSize: deviceHeight * 0.020,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

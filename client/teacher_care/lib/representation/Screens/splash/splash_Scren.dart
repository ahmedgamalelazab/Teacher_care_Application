import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_care/representation/Screens/splash/onBoardScreen.dart';
import '../../../database/internalRepository/authDataBaseRepository.dart';
import '../auth/app_auth_screen.dart';
import '../room/videoConference/Room_VideoConference.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class ApplicationSplashScreen extends StatefulWidget {
  static const String SCREEN_ROUTE = '/ApplicationSplashScreen';
  ApplicationSplashScreen({Key? key}) : super(key: key);

  @override
  _ApplicationSplashScreenState createState() =>
      _ApplicationSplashScreenState();
}

class _ApplicationSplashScreenState extends State<ApplicationSplashScreen> {
  bool isAlreadyOnBoard = true;
  _startOnBoardState(BuildContext context) async {
    await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
        .authInternalDataBaseHelper
        .openDataBase();
    final initializeResponse =
        await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
            .authInternalDataBaseHelper
            .fetchOnBoardState();
    if (initializeResponse.length == 0) {
      // await Navigator.of(context).pushNamed(OnBoardScreen.PAGE_ROUTE);
      // await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
      //     .authInternalDataBaseHelper
      //     .initializeOnBoard();
      // Navigator.of(context).pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
      isAlreadyOnBoard = false;
    } else {
      // Navigator.of(context).pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
      isAlreadyOnBoard = true;
    }
    print(initializeResponse);
  }

  @override
  Widget build(BuildContext context) {
    // _startOnBoardState(context);
    // final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/images/logo/Application_Logo.png',
        screenFunction: () async {
          await _startOnBoardState(context);
          return isAlreadyOnBoard == false ? OnBoardScreen() : UserAuthScreen();
        },
        splashTransition: SplashTransition.sizeTransition,
        centered: true,
        animationDuration: Duration(seconds: 5),
        pageTransitionType: PageTransitionType.bottomToTop,

        // pageTransitionType: PageTransitionType.scale,
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Container(
    //       width: device_width * 0.8,
    //       child: Image.asset('assets/images/logo/Application_Logo.png'),
    //     ),
    //   ),
    // );
  }
}

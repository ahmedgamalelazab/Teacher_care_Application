import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:teacher_care/application_colors/application_colors.dart';
import 'package:teacher_care/database/internalRepository/authDataBaseRepository.dart';
import 'package:teacher_care/representation/Screens/auth/app_auth_screen.dart';
import 'package:sizer/sizer.dart';

class OnBoardScreen extends StatefulWidget {
  static const String PAGE_ROUTE = '/OnBoardScreen';
  OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _pageController = PageController();

  final List<OnBoardModel> onBoardData = [
    const OnBoardModel(
      title: "المنصة توفر لك وسائل المواكبة",
      description:
          "المنصة توفر لكل من الطالب والمعلم الوسيلة لمواكبة تحديات التقدم التكنولوجى الذى يمر به العالم",
      imgUrl: "assets/images/superHeroWithLikeOnBoard.png",
    ),
    const OnBoardModel(
      title: "المنصة بها كل وسائل التواصل الممكنة",
      description:
          "يمكن للطالب والمعلم التواصل و المتابعة من خلال الغرفة الإلكترونية التى توفرها المنصة حيث يتوفر بالغرفة الإتصال بالفيديو والرسائل الإلكترونية و مشاركة نوافذ الهاتف وأكثر ",
      imgUrl: 'assets/images/onlineCallsOnBoard.png',
    ),
    const OnBoardModel(
      title: "المنصة ستوفر لك الوقت والمجهود",
      description:
          "يمكن للمنصة أن تقوم بإجراء الإمتحانات والتصحيح بسرعة فائقة دون الحاجة لقضاء الوقت فى التصحيح والمراجعة",
      imgUrl: 'assets/images/saveTimeOnBoard.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final deviceOrientation = MediaQuery.of(context).orientation;
    print(deviceOrientation);

    return Scaffold(
      backgroundColor: ApplicationColors.tryThsColorTwo(),
      body: Provider<OnBoardState>(
        create: (context) => OnBoardState(),
        child: OnBoard(
          // imageHeight: deviceWidth * 0.8,
          // imageWidth: deviceWidth * 0.8,
          imageHeight: deviceOrientation == Orientation.portrait ? 35.h : 10.h,
          imageWidth: deviceOrientation == Orientation.portrait ? 35.h : 10.h,
          onBoardData: onBoardData,
          pageController: _pageController,
          onSkip: () {
            print('skipped');
          },
          onDone: () async {
            await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
                .authInternalDataBaseHelper
                .initializeOnBoard();
            Navigator.of(context)
                .pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
          },
          pageIndicatorStyle: PageIndicatorStyle(
            width: deviceOrientation == Orientation.portrait ? 40.w : 40.w,
            inactiveColor: Colors.yellow,
            activeColor: Color(0xffEACE09),
            inactiveSize: Size(1.w, 2.h),
            activeSize: Size(3.w, 4.h),
          ),
          skipButton: TextButton(
            onPressed: () async {
              // print('skipped');
              await RepositoryProvider.of<AuthInternalDataBaseRepository>(
                      context)
                  .authInternalDataBaseHelper
                  .initializeOnBoard();
              Navigator.of(context)
                  .pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Color(0xffEACE09)),
            ),
          ),
          nextButton: Consumer<OnBoardState>(
            builder: (BuildContext context, OnBoardState state, Widget? child) {
              return InkWell(
                onTap: () => _onNextTap(state, context),
                child: Container(
                  width:
                      deviceOrientation == Orientation.portrait ? 50.w : 70.w,
                  height: deviceOrientation == Orientation.portrait ? 8.h : 5.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.yellow, Color(0xffEACE09)],
                    ),
                  ),
                  child: Text(
                    state.isLastPage ? "إنهاء" : "التالى",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          titleStyles: GoogleFonts.cairo(
            // fontSize: deviceHeight * 0.028,
            fontSize: deviceOrientation == Orientation.portrait ? 16.sp : 12.sp,
            fontWeight: FontWeight.w800,
            color: Colors.yellow,
          ),
          descriptionStyles: GoogleFonts.cairo(
            // fontSize: deviceHeight * 0.020,
            fontSize: deviceOrientation == Orientation.portrait ? 11.sp : 7.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState, BuildContext context) async {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      print("done");
      await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
          .authInternalDataBaseHelper
          .initializeOnBoard();
      Navigator.of(context).pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
    }
  }
}

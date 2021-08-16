// in this module i will construct the teacher management system

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/application_colors/application_colors.dart';
import 'package:teacher_care/generalLogic/navBarProvider.dart';
import 'package:teacher_care/representation/Screens/Users/admin/usersDetailedScreen/admin_parents_detailed_screen.dart';
import 'package:teacher_care/representation/Screens/Users/admin/usersDetailedScreen/admin_students_detailed_screen.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/Teacher_exams/teacher_exams.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/adding_room/teacher_rooms.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/studentDetailedScreenTeacher.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacher.dart';
import 'package:teacher_care/representation/Screens/auth/generic_log_out_Screen.dart';
import 'package:teacher_care/server/logic/userControlScreenBloc/userutilscontrolscreen_bloc.dart';

class TeacherDashBoardScreen extends StatefulWidget {
  static const String PageRoute = '/TeacherDashBoardScreen';
  TeacherDashBoardScreen({Key? key}) : super(key: key);

  @override
  _TeacherDashBoardScreenState createState() => _TeacherDashBoardScreenState();
}

class _TeacherDashBoardScreenState extends State<TeacherDashBoardScreen> {
  //section of data
  dynamic studentsTotalNumberInSystem;
  dynamic teacherTotalRoomsInSystem;

  List<String> systemObjects = ["students", "rooms", "Exams"];

  late String? user_id;
  late String teacherToken;
  //dynamic userState;
  // teacher data from the server
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final argument =
        ModalRoute.of(context)!.settings.arguments as Map<String?, String?>;
    if (!isInit) {
      BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
        FetchUserScreenData(userToken: argument['teacherToken']!),
      );
      isInit = true;
    }
    return Scaffold(
      backgroundColor:
          ApplicationColors.getApplicationRecommendedBackgroundColor(),
      //❎ Navigation  part will be editable later on here ❎
      bottomNavigationBar: Consumer<ApplicationNavigationBarState>(
        builder: (context, state, child) => ConvexAppBar(
          backgroundColor: ApplicationColors.getApplicationNavBarsColor(),
          color: ApplicationColors.getActiveIconColor(),
          activeColor: ApplicationColors.getActiveIconColor(),
          // buttonBackgroundColor: Color(0xff283C63),
          items: <TabItem>[
            TabItem(
              icon: Icons.person,
              title: 'profile',
            ),
            TabItem(icon: Icons.list_rounded, title: 'Management'),
            TabItem(icon: Icons.settings, title: 'settings'),
          ],
          initialActiveIndex: state.getCurrentIndex(),
          onTap: (index) async {
            Provider.of<ApplicationNavigationBarState>(context, listen: false)
                .overLapScreen(index);
            switch (index) {
              case 0:
                Navigator.of(context)
                    .pushReplacementNamed(Teacher_Screen.SCREEN_ROUTE);
                break;
              case 1:
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var user_id = prefs.getString('user_id') ?? 'no data';
                var teacherToken = prefs.getString('teacher_token');
                //go to control screen
                Navigator.of(context).pushReplacementNamed(
                    TeacherDashBoardScreen.PageRoute,
                    arguments: {"teacherToken": teacherToken});
                break;
              case 2:
                Navigator.of(context).pushReplacementNamed(
                    ApplicationGenericLogOutScreen.ScreenRoute);
                //after it will be gone we will get off
                break;
              default:
                break;
            }
          },
        ),
      ),
      body:
          BlocConsumer<UserutilscontrolscreenBloc, UserutilscontrolscreenState>(
        builder: (context, state) {
          if (state is UserControlScreenDataLoading) {
            return Container(
              width: deviceWidth,
              height: deviceHeight,
              alignment: Alignment.center,
              child: Container(
                width: deviceHeight * 0.1,
                height: deviceHeight * 0.1,
                child: LoadingIndicator(
                  color: ApplicationColors.tryThsColorTwo(),
                  indicatorType: Indicator.squareSpin,
                ),
              ),
            );
          } else if (state is UserControlScreenDataLoaded) {
            studentsTotalNumberInSystem =
                state.response['data']['total_students_in_system'];
            teacherTotalRoomsInSystem =
                state.response['data']['total_teacher_rooms_in_system'];
            // parentsTotalNumberInSystem =
            //     state.response['data']['total_parents_in_system'];
            return RefreshIndicator(
              onRefresh: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var user_id = prefs.getString('user_id') ?? 'no data';
                var teacherToken = prefs.getString('teacher_token');
                //go to control screen
                Navigator.of(context).pushReplacementNamed(
                    TeacherDashBoardScreen.PageRoute,
                    arguments: {"teacherToken": teacherToken});
                BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                  FetchUserScreenData(
                      userToken: teacherToken ?? 'error'), //!token
                );
                return Future.value();
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: deviceWidth * 0.50,
                  mainAxisExtent: deviceWidth * 0.50,
                  // crossAxisSpacing: 15.00,
                  // mainAxisSpacing: 15.00,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: systemObjects.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Card(
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        fit: StackFit.expand,
                        children: [
                          _detectProperImageView(index),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: deviceWidth * 0.10,
                                backgroundColor:
                                    ApplicationColors.tryThsColorTwo()
                                        .withOpacity(0.7),
                                //TODO FETCH THIS NUMBERS FROM THE SERVER
                                child: _adminControlScreenObjectNumbers(
                                    index, deviceWidth),
                              ),
                              SizedBox(
                                height: deviceWidth * 0.045,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: deviceWidth * 0.090,
                              width: deviceWidth * 0.75,
                              alignment: Alignment.center,
                              color: ApplicationColors.tryThsColorTwo(),
                              child: Text(
                                systemObjects[index],
                                style: GoogleFonts.montserrat(
                                  fontSize: deviceWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              // we need a function will split up all the users to multiple screens to show the users
                              onTap: () {
                                _routeToUsersDetails(index, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ApplicationColors.tryThsColorTwo(),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            );
          }
          //if all fails
          return Container(
            child: Center(child: Text('error ? ')),
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  //this function will control the InkWell direction
  _routeToUsersDetails(int index, BuildContext context) async {
    switch (index) {
      //moderators details screen
      case 0:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var user_id = prefs.getString('user_id') ?? 'no data';
        var teacherToken = prefs.getString('teacher_token');
        Navigator.of(context)
            .pushNamed(StudentDetailedScreenTeacherDashBoard.PageRoute)
            .then(
              (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                FetchUserScreenData(userToken: teacherToken!),
              ),
            );
        break;
      case 1:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var user_id = prefs.getString('user_id') ?? 'no data';
        var teacherToken = prefs.getString('teacher_token');
        Navigator.of(context).pushNamed(TeacherRoomsScreen.PageRoute).then(
              (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                FetchUserScreenData(userToken: teacherToken!),
              ),
            );
        //!adding rooms to the current teacher
        print('rooms and adding rooms');
        break;
      case 2:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var user_id = prefs.getString('user_id') ?? 'no data';
        var teacherToken = prefs.getString('teacher_token');
        Navigator.of(context).pushNamed(TeacherExams.Page_route).then(
              (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                FetchUserScreenData(userToken: teacherToken!),
              ),
            );
        break;
      //   break;
      default:
        break;
    }
  }

  _adminControlScreenObjectNumbers(int index, double deviceWidth) {
    // index 0 => moderatos  , 1 => teachers , 2=>students , 3=> parents
    switch (index) {
      case 0:
        return FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              studentsTotalNumberInSystem.toString(),
              style: GoogleFonts.montserrat(
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: ApplicationColors.getHeaderFontsColor(),
              ),
            ),
          ),
        );
      case 1:
        return FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              //! fix me get room numbers
              teacherTotalRoomsInSystem.toString(),
              style: GoogleFonts.montserrat(
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: ApplicationColors.getHeaderFontsColor(),
              ),
            ),
          ),
        );
      case 2:
        return FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              //! fix me == get the total number of exams for each teacher
              0.toString(),
              style: GoogleFonts.montserrat(
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: ApplicationColors.getHeaderFontsColor(),
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  //the function is a part of the screen
  _detectProperImageView(int index) {
    switch (index) {
      case 0:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/students.jpg',
            fit: BoxFit.cover,
          ),
        );
      case 1:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/rooms.jpg',
            fit: BoxFit.cover,
          ),
        );
      case 2:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/exams.jpg',
            fit: BoxFit.cover,
          ),
        );
      default:
        return Container();
    }
  }
}

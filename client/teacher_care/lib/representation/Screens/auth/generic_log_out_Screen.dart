import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/application_colors/application_colors.dart';
import 'package:teacher_care/generalLogic/navBarProvider.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacher.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacherDashBoard.dart';
import 'package:teacher_care/server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';

import 'app_auth_screen.dart';
import 'app_log_out_screen.dart';

class ApplicationGenericLogOutScreen extends StatelessWidget {
  static const ScreenRoute = './ApplicationGenericLogOutScreen';
  const ApplicationGenericLogOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var user_id = prefs.getString('user_id') ?? 'no data';
                  var teacherToken = prefs.getString('teacher_token');
                  print(teacherToken);
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
        body: ListView(
          children: [
            Container(
              height: deviceHeight * 0.080,
              width: deviceWidth,
              alignment: Alignment.center,
              color: ApplicationColors.tryThsColorTwo(),
              child: ListTile(
                title: Text(
                  'Log out',
                  style: GoogleFonts.montserrat(
                    fontSize: deviceHeight * 0.020,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(Icons.logout,
                    color: Colors.white, size: deviceHeight * 0.040),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var user_id = prefs.getString('user_id') ?? 'no data';
                  var teacherToken = prefs.getString('teacher_token');
                  var teacher_id = prefs.getString('teacher_id');
                  print(teacher_id);
                  //the teacher has to connect to the server side and log himself out
                  Provider.of<UserAuthBlocBloc>(context, listen: false)
                      .add(LogUserOut(user_id: teacher_id ?? "no data"));
                  Provider.of<ApplicationNavigationBarState>(context,
                          listen: false)
                      .overLapScreen(0);
                  await Navigator.of(context)
                      .pushNamed(ApplicationLogOutScreen.ScreenRoute);
                  //after it will be gone we will get off
                  Navigator.of(context)
                      .pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
                },
              ),
            ),
          ], // composition relation ship
        ),
      ),
    );
  }
}

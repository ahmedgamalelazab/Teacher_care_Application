//coding the auth screen loading
//TODO implements internal data storeage to store the user credentials i will use only the token and i will store it in the internal storeage
//TODO each time the user will try to open up his account we will search for this token and if not exist we will force login scren to the user

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:teacher_care/representation/Screens/Users/admin/admin.dart';
import 'package:teacher_care/representation/Screens/Users/moderators/moderator.dart';
import 'package:teacher_care/representation/Screens/Users/student/student.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacher.dart';
import 'package:teacher_care/representation/Screens/auth/app_auth_screen.dart';
import 'package:teacher_care/server/logic/teacher_data_bloc/teacherdata_bloc.dart';
import 'package:teacher_care/server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_Loading_Screen extends StatelessWidget {
  static const String SCREEN_ROUTE = '/Auth_Loading_Screen';
  const Auth_Loading_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device_width = MediaQuery.of(context).size.width;
    final device_height = MediaQuery.of(context).size.height;
    return BlocConsumer<UserAuthBlocBloc, UserAuthBlocState>(
        builder: (builder, state) => Scaffold(
              body: Container(
                height: device_height,
                width: device_width,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: device_height * 0.1,
                        height: device_height * 0.1,
                        child: LoadingIndicator(
                          color: Color(0xff283C63),
                          indicatorType: Indicator.squareSpin,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        listener: (context, state) async {
          // from this screen we will split the whole entire application
          if (state is AdminAuthLogged) {
            //navigate the application to the teacher
            Navigator.of(context)
                .pushReplacementNamed(Admin_profile_screen.SCREEN_ROUTE);
          } else if (state is ModeratorAuthLogged) {
            Navigator.of(context)
                .pushReplacementNamed(Moderator_Screen.SCREEN_ROUTE);
          } else if (state is TeacherAuthLogged) {
            print(state.data);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            await prefs.setString('user_id', state.data['user_id']);
            await prefs.setString('teacher_id', state.data['teacher_id']);
            await prefs.setString('teacher_token', state.data['teacher_token']);
            final user_id = prefs.getString('user_id') ?? 'no data';
            final teacherToken = prefs.getString('teacher_token');
            BlocProvider.of<TeacherdataBloc>(context)
                .add(FetchTeacherData(userToken: teacherToken ?? 'no token'));
            Navigator.of(context).pushReplacementNamed(
                Teacher_Screen.SCREEN_ROUTE,
                arguments: {teacherToken: teacherToken});
          } else if (state is StudentAuthLogged) {
            //do some code
            Navigator.of(context)
                .pushReplacementNamed(Student_Screen.SCREEN_ROUTE);
          } else if (state is Auth_FAILED_FOR_NO_REASON) {
            Navigator.of(context)
                .pushReplacementNamed(UserAuthScreen.SCREEN_ROUTE);
          }
          //TODO implements the parent route solitter
        });
  }
}

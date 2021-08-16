//coding the auth screen loading

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:teacher_care/representation/Screens/Users/admin/admin.dart';
import 'package:teacher_care/representation/Screens/Users/admin/admin_add_teacher/admin_add_teacher_successfully.dart';
import 'package:teacher_care/representation/Screens/Users/moderators/moderator.dart';
import 'package:teacher_care/representation/Screens/Users/student/student.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacher.dart';
import 'package:teacher_care/representation/Screens/auth/app_auth_screen.dart';
import 'package:teacher_care/server/logic/AdminTeacherRegisterBloc/adminteacherregister_bloc.dart';
import 'package:teacher_care/server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';

class AdminAddTeacherLoadingScreenWithSplitter extends StatelessWidget {
  static const String SCREEN_ROUTE =
      '/AdminAddTeacherLoadingScreenWithSplitter';
  const AdminAddTeacherLoadingScreenWithSplitter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device_width = MediaQuery.of(context).size.width;
    final device_height = MediaQuery.of(context).size.height;
    return BlocConsumer<AdminteacherregisterBloc, AdminteacherregisterState>(
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
        listener: (context, state) {
          // from this screen we will split the whole entire application
          if (state is RegisteredTeacherInTheSystem) {
            //navigate the application to the teacher
            Navigator.of(context)
                .pushNamed(AdminAddTeacherSuccessfullyAddedToSystem.ScreenRoute)
                .then(
                  (_) => Navigator.of(context).pop(),
                );
          } else if (state is RegisteringTeacherInTheSystemERROR) {
            //TODO implement an error screen and navigate him to prev screen
          }
        });
  }
}

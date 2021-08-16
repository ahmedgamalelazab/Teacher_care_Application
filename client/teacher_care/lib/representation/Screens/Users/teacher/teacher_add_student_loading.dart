import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/generalLogic/navBarProvider.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacher.dart';
import 'package:teacher_care/server/logic/TeacherRegisterStudent/teacherregisterstudent_bloc.dart';
import 'package:sizer/sizer.dart';

class TeacherAddStudentLoadingScreen extends StatefulWidget {
  static const String PAGE_ROUTE = '/TeacherAddStudentLoadingScreen';
  TeacherAddStudentLoadingScreen({Key? key}) : super(key: key);

  @override
  _TeacherAddStudentLoadingScreenState createState() =>
      _TeacherAddStudentLoadingScreenState();
}

class _TeacherAddStudentLoadingScreenState
    extends State<TeacherAddStudentLoadingScreen> {
  _loadMainScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id') ?? 'no data';
    var teacherToken = prefs.getString('teacher_token');
    var teacher_id = prefs.getString('teacher_id');
    Provider.of<ApplicationNavigationBarState>(context, listen: false)
        .overLapScreen(0);
    Navigator.of(context).pushReplacementNamed(Teacher_Screen.SCREEN_ROUTE,
        arguments: {teacherToken: teacherToken});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<TeacherregisterstudentBloc,
            TeacherregisterstudentState>(
      builder: (context, state) {
        if (state is TellTeacherOkAnimatedCharacter) {
          return Center(
            child: Container(
              height: 40.h,
              width: 40.w,
              child: Image.asset('assets/images/success.png'),
            ),
          );
        } else if (state is LoadedStudentData) {
          _loadMainScreen(context);
        } else if (state is LoadingStudentRegisterData) {
          return Center(
            child: Container(
              height: 40.h,
              width: 30.w,
              child: LoadingIndicator(
                color: Color(0xff283C63),
                indicatorType: Indicator.ballBeat,
              ),
            ),
          );
        }
        return Container();
      },
      listener: (context, state) {},
    ));
  }
}

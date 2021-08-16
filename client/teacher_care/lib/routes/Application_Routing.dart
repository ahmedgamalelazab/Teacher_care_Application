import 'package:flutter/cupertino.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/Teacher_exams/teacher_exams.dart';

import '../representation/Screens/Users/admin/admin.dart';
import '../representation/Screens/Users/admin/admin_add_teacher/admin_add_teacher.dart';
import '../representation/Screens/Users/admin/admin_add_teacher/admin_add_teacher_loading.dart';
import '../representation/Screens/Users/admin/admin_add_teacher/admin_add_teacher_successfully.dart';
import '../representation/Screens/Users/admin/admin_edit_screen.dart';
import '../representation/Screens/Users/admin/usersDetailedScreen/admin_moderators_detailed_screen.dart';
import '../representation/Screens/Users/admin/usersDetailedScreen/admin_parents_detailed_screen.dart';
import '../representation/Screens/Users/admin/usersDetailedScreen/admin_students_detailed_screen.dart';
import '../representation/Screens/Users/admin/usersDetailedScreen/admin_teachers_detailed_screen.dart';
import '../representation/Screens/Users/loading_screen/auth_loading_screen.dart';
import '../representation/Screens/Users/moderators/moderator.dart';
import '../representation/Screens/Users/parent/parent.dart';
import '../representation/Screens/Users/student/student.dart';
import '../representation/Screens/Users/teacher/adding_room/teacher_add_room.dart';
import '../representation/Screens/Users/teacher/adding_room/teacher_adding_room_loading.dart';
import '../representation/Screens/Users/teacher/adding_room/teacher_rooms.dart';
import '../representation/Screens/Users/teacher/studentDetailedScreenTeacher.dart';
import '../representation/Screens/Users/teacher/teacher.dart';
import '../representation/Screens/Users/teacher/teacherCreateStudent.dart';
import '../representation/Screens/Users/teacher/teacherDashBoard.dart';
import '../representation/Screens/Users/teacher/teacher_add_student_loading.dart';
import '../representation/Screens/auth/app_auth_screen.dart';
import '../representation/Screens/auth/app_log_out_screen.dart';
import '../representation/Screens/auth/generic_log_out_Screen.dart';
import '../representation/Screens/room/videoConference/Room_VideoConference.dart';
import '../representation/Screens/splash/onBoardScreen.dart';
import '../representation/Screens/splash/splash_Scren.dart';

class ApplicationRouting {
  //this class will handle all the Application routes

  static Map<String, Widget Function(BuildContext)> applicationRoutes() {
    return {
      Meeting.SCREEN_ROUTE: (context) => Meeting(),
      ApplicationSplashScreen.SCREEN_ROUTE: (context) =>
          ApplicationSplashScreen(),
      UserAuthScreen.SCREEN_ROUTE: (context) => UserAuthScreen(),
      Auth_Loading_Screen.SCREEN_ROUTE: (context) => Auth_Loading_Screen(),
      Admin_profile_screen.SCREEN_ROUTE: (context) => Admin_profile_screen(),
      Moderator_Screen.SCREEN_ROUTE: (context) => Moderator_Screen(),
      Teacher_Screen.SCREEN_ROUTE: (context) => Teacher_Screen(),
      Student_Screen.SCREEN_ROUTE: (context) => Student_Screen(),
      Parent_Screen.SCREEN_ROUTE: (context) => Parent_Screen(),
      PatchUserBioScreen.SCREEN_ROUTE: (context) => PatchUserBioScreen(),
      TeacherDetailedScreenAdmin.ScreenRoute: (context) =>
          TeacherDetailedScreenAdmin(),
      ModeratorDetailedScreenAdmin.ScreenRoute: (context) =>
          ModeratorDetailedScreenAdmin(),
      StudentsDetailedScreenAdmin.ScreenRoute: (context) =>
          StudentsDetailedScreenAdmin(),
      ParentsDetailedScreenAdmin.ScreenRoute: (context) =>
          ParentsDetailedScreenAdmin(),
      AdminCreateTeacherFormScreen.ScreenRoute: (context) =>
          AdminCreateTeacherFormScreen(),
      AdminAddTeacherLoadingScreenWithSplitter.SCREEN_ROUTE: (context) =>
          AdminAddTeacherLoadingScreenWithSplitter(),
      AdminAddTeacherSuccessfullyAddedToSystem.ScreenRoute: (context) =>
          AdminAddTeacherSuccessfullyAddedToSystem(),
      ApplicationLogOutScreen.ScreenRoute: (context) =>
          ApplicationLogOutScreen(),
      ApplicationGenericLogOutScreen.ScreenRoute: (context) =>
          ApplicationGenericLogOutScreen(),
      OnBoardScreen.PAGE_ROUTE: (context) => OnBoardScreen(),
      TeacherDashBoardScreen.PageRoute: (context) => TeacherDashBoardScreen(),
      StudentDetailedScreenTeacherDashBoard.PageRoute: (context) =>
          StudentDetailedScreenTeacherDashBoard(),
      TeacherCreateStudentScreen.PAGE_ROUTE: (context) =>
          TeacherCreateStudentScreen(),
      TeacherAddStudentLoadingScreen.PAGE_ROUTE: (context) =>
          TeacherAddStudentLoadingScreen(),
      TeacherRoomsScreen.PageRoute: (context) => TeacherRoomsScreen(),
      TeacherAddRoomScreen.PAGE_ROUTE: (context) => TeacherAddRoomScreen(),
      TeacherAddingRoomsLoadingScreen.PAGE_ROUTE: (context) =>
          TeacherAddingRoomsLoadingScreen(),
      TeacherExams.Page_route: (context) => TeacherExams(),
    };
  }

  static String initialRoute() {
    return ApplicationSplashScreen.SCREEN_ROUTE;
    // return AdminAddTeacherSuccessfullyAddedToSystem.ScreenRoute;
  }
}

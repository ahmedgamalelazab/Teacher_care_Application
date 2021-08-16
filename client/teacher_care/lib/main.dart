import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:teacher_care/server/data_providers/teacher_create_room.dart';
import 'package:teacher_care/server/data_providers/teacher_student_register_to_system.dart';
import 'package:teacher_care/server/logic/TeacherCreateRoom/teachercreatreroom_bloc.dart';
import 'package:teacher_care/server/logic/TeacherRegisterStudent/teacherregisterstudent_bloc.dart';
import 'package:teacher_care/server/repository/TeacherCreateRoomRepository.dart';
import 'package:teacher_care/server/repository/teacherRegisterStudentRepository.dart';
import 'generalLogic/navBarProvider.dart';
import 'representation/Screens/splash/splash_Scren.dart';
import 'server/logic/teacher_data_bloc/teacherdata_bloc.dart';
import 'server/data_providers/teacher_data.dart';
import 'server/repository/teacher_data_repository.dart';

import 'database/authDataBase.dart';
import 'database/internalRepository/authDataBaseRepository.dart';
import 'representation/componets/Themes/Application_themes.dart';
import 'routes/Application_Routing.dart';
import 'server/data_providers/admin_teacher_register_to_system.dart';
import 'server/data_providers/auth_api.dart';
import 'server/data_providers/userUtilsApi.dart';
import 'server/logic/AdminTeacherRegisterBloc/adminteacherregister_bloc.dart';
import 'server/logic/UserUploadFilesBloc/useruploadimagesutilsbloc_bloc.dart';
import 'server/logic/userControlScreenBloc/userutilscontrolscreen_bloc.dart';
import 'server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';
import 'server/repository/adminTeacherRegisterRepository.dart';
// import 'package:device_preview/device_preview.dart';

import 'server/repository/auth_repository.dart';
import 'server/repository/userControlScreenDataRepository.dart';
import 'server/repository/userUtilsRepository.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // ),
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthInternalStorageDataBaseHelper dbHelper;

  _initInternalStorage() async {
    dbHelper = new AuthInternalStorageDataBaseHelper();
    await dbHelper.openDataBase();
  }

  _init() async {
    await _initInternalStorage();
  }

  @override
  void initState() {
    // if the file exist it will not open another one
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            userApi: UserAuth(),
            internalStorage: dbHelper,
          ),
        ),
        RepositoryProvider(
          create: (context) => UserUploadImagesUtilsRepository(
            userUtilsApi: UserUtilsImplementation(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UserUtilsControlScreenRepository(
            userUtilsApi: UserUtilsImplementation(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AdminTeacherRegisterRepository(
            adminTeacherRegisterApi: AdminTeacherRegister(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AuthInternalDataBaseRepository(
              authInternalDataBaseHelper: dbHelper),
        ),
        RepositoryProvider(
          create: (context) => TeacherDataRepository(
            teacherApi: TeacherDataProvider(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TeacherRegisterStudentRepository(
            teacherRegisterApi: Teacher_Register_To_System(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TeacherCreateRoomRepository(
            teacherCreateRoomApi: TeacherCreateRoom(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserAuthBlocBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => UseruploadimagesutilsblocBloc(
              uploadImagesRepository:
                  RepositoryProvider.of<UserUploadImagesUtilsRepository>(
                      context),
            ),
          ),
          BlocProvider(
            create: (context) => UserutilscontrolscreenBloc(
              userControlScreenRepository:
                  RepositoryProvider.of<UserUtilsControlScreenRepository>(
                      context),
            ),
          ),
          BlocProvider(
            create: (context) => AdminteacherregisterBloc(
              adminTeacherRegisteringRepository:
                  RepositoryProvider.of<AdminTeacherRegisterRepository>(
                      context),
            ),
          ),
          BlocProvider(
            create: (context) => TeacherdataBloc(
              teacherDataRepository:
                  RepositoryProvider.of<TeacherDataRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => TeacherregisterstudentBloc(
              teacherRegisterStudentRepository:
                  RepositoryProvider.of<TeacherRegisterStudentRepository>(
                      context),
            ),
          ),
          BlocProvider(
            create: (context) => TeachercreatreroomBloc(
              teacherCreateRoomRepository:
                  RepositoryProvider.of<TeacherCreateRoomRepository>(context),
            ),
          ),
        ],
        child: ChangeNotifierProvider(
          create: (context) => ApplicationNavigationBarState(),
          child: Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              // locale: DevicePreview.locale(context), // Add the locale here
              // builder: DevicePreview.appBuilder, // Add the builder here
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              theme: ApplicationThemes.lightTheme,
              darkTheme: ApplicationThemes.darkTheme,
              routes: ApplicationRouting.applicationRoutes(),
              initialRoute: ApplicationRouting.initialRoute(),
              // home: ApplicationSplashScreen(),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dbHelper.closeDB();
    super.dispose();
  }
}

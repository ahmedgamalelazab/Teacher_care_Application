import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:teacher_care/server/logic/userControlScreenBloc/userutilscontrolscreen_bloc.dart';
import 'teacherDashBoard.dart';
import 'profileImagesPreviewer/imagePreview.dart';
import '../../../../generalLogic/navBarProvider.dart';
import '../admin/admin_edit_screen.dart';
import '../../auth/app_auth_screen.dart';
import '../../auth/app_log_out_screen.dart';
import '../../auth/generic_log_out_Screen.dart';
import '../../../componets/constant/userUploadImagesUtils.dart';
import '../../../../server/logic/UserUploadFilesBloc/useruploadimagesutilsbloc_bloc.dart';
import '../../../../server/logic/teacher_data_bloc/teacherdata_bloc.dart';
import '../../../../utils/js/js_console_log.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../../../../application_colors/application_colors.dart';
import '../../../../server/repository/auth_repository.dart';

import 'package:photo_view/photo_view.dart';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:sizer/sizer.dart';

// i will connect this screen with the bloc to obtain the latest state from the bloc and after that i will
//create the bloc and continue the profile work up to finish it all
// all the data i need registered in the auth repository

class Teacher_Screen extends StatefulWidget {
  static const String SCREEN_ROUTE = '/Teacher_Screen';
  const Teacher_Screen({Key? key}) : super(key: key);

  @override
  _Teacher_ScreenState createState() => _Teacher_ScreenState();
}

class _Teacher_ScreenState extends State<Teacher_Screen> {
  //hashing the screen into numbers then call a splitter function
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
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
      body: BlocConsumer<TeacherdataBloc, TeacherdataState>(
        builder: (context, state) {
          if (state is TeacherDataLoading) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is TeacherDataLoaded) {
            return TeacherProfileScreen(teacher: state.teacherData);
          }
          return Center(
            child: Container(
              child: Text('error during Loading the teacher data'),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({Key? key, required this.teacher})
      : super(key: key);
  final Map<String, dynamic> teacher;
  @override
  _TeacherProfileScreenState createState() =>
      _TeacherProfileScreenState(teacher: teacher);
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  late String? user_id;
  late String? teacherToken;
  //dynamic userState;
  final Map<String, dynamic> teacher; // teacher data from the server

  _TeacherProfileScreenState({required this.teacher});

  _fetchTeacherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id') ?? 'no data';
    teacherToken = prefs.getString('teacher_token');
    // print(user_id);
    // print(teacherToken);
  }

  ImagePicker picker = new ImagePicker();
  dynamic imageFile;
  dynamic pickImageError;
  dynamic file;
  dynamic backgroundImageFile;

  @override
  void initState() {
    _fetchTeacherData();
    super.initState();
  }

  final snappingSheetController = SnappingSheetController();
  Map<String, dynamic> userImagesData = {
    "user_token":
        "", //user id here mention the user child role not the parent user id
    "user_profile_image_file": "",
    "user_cover_image_file": "",
  };

  @override
  Widget build(BuildContext context) {
    final device_width = MediaQuery.of(context).size.width;
    final device_height = MediaQuery.of(context).size.height;
    final deviceOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor:
          ApplicationColors.getApplicationRecommendedBackgroundColor(),
      body: SnappingSheet(
        lockOverflowDrag: true, // (Recommended) Set this to true.
        controller: snappingSheetController,
        grabbing: GrabbingWidget(),
        grabbingHeight: deviceOrientation == Orientation.portrait ? 7.h : 6.h,
        //✅ sheet below teacher data ✅
        sheetBelow: SnappingSheetContent(
          draggable: false,
          // TODO: Add your sheet content here
          child: Scaffold(
            // height: device_height * 0.5,
            // color: Colors.black,
            body: Scaffold(
              backgroundColor:
                  ApplicationColors.getApplicationRecommendedBackgroundColor(),
              body: SingleChildScrollView(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 100.h,
                      child: OctoImage(
                        image: CachedNetworkImageProvider(
                            'http://192.168.0.106:4040${teacher['teacher_backGround_image']}'),
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        ),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 100.h,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    Container(
                      height: 70.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: ApplicationColors.tryThsColorTwo(),
                        // borderRadius: BorderRadius.circular(80),
                      ),
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['user_role'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_city,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['address_information_english']['country'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_searching,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['address_information_english']
                                  ['governorate_en'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['address_information_english']['city_en'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ...teacher['teacher_level'].map<Widget>((element) {
                            return ListTile(
                              leading: Icon(
                                Icons.class__outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                element['level_name_en'],
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          ...teacher['teacher_subject'].map<Widget>((element) {
                            return ListTile(
                              leading: Icon(
                                Icons.subject,
                                color: Colors.white,
                              ),
                              title: Text(
                                element['subject_name_en'],
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          ListTile(
                            leading: Icon(
                              Icons.phone_enabled_outlined,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['teacher_phone'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.mail_outline,
                              color: Colors.white,
                            ),
                            title: Text(
                              teacher['user_information']['user_email'],
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*
                    Container(
                      // color: Colors.red,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Console.log('edit this bio');
                          Navigator.of(context).pushNamed(
                              PatchUserBioScreen.SCREEN_ROUTE,
                              arguments: {
                                "user_bio": teacher['teacher_bio'] ??
                                    'No User Bio added yet',
                                "token": teacherToken,
                              }).then(
                            (_) => Future.value(
                              [
                                BlocProvider.of<TeacherdataBloc>(context,
                                        listen: false)
                                    .add(
                                  FetchTeacherData(
                                      userToken: teacherToken ?? 'no token'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          size: deviceOrientation == Orientation.portrait
                              ? 3.h
                              : 5.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ),
          ),
        ),
        // ),
        //sheet above teacher upload control the profile will be here  🔑🔑🔑🔑🔑🔑🔑
        sheetAbove: SnappingSheetContent(
          draggable: true,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: device_height * 0.5,
                    width: device_width,
                    alignment: Alignment.center,
                    color: Colors.amber,
                    child: Stack(
                      fit: StackFit.expand,
                      //TODO implements the logic of upload images from device or camera
                      alignment: AlignmentDirectional.center,
                      clipBehavior: Clip.none, // to make overflow
                      children: [
                        Container(
                          height: device_height * 0.5,
                          width: device_width,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.zero,
                            child: teacher['teacher_backGround_image'] == null
                                ? BlocConsumer<UseruploadimagesutilsblocBloc,
                                    UseruploadimagesutilsblocState>(
                                    builder: (context, state) {
                                      if (state is LoadingUploadImageProcess) {
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          child: LoadingIndicator(
                                            color: Color(0xff283C63),
                                            indicatorType:
                                                Indicator.ballRotateChase,
                                          ),
                                        );
                                      } else if (state is UploadedImage) {
                                        //fetch the url and use it here
                                        print(state.uploadResponse);
                                        return Container(
                                          height: device_height * 0.5,
                                          width: device_width,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileImagePreviewer(
                                                    path:
                                                        'http://192.168.0.106:4040${teacher['teacher_backGround_image']}',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  'http://192.168.0.106:4040${teacher['teacher_backGround_image']}'),
                                              placeholderBuilder:
                                                  OctoPlaceholder.blurHash(
                                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                              ),
                                              errorBuilder: OctoError.icon(
                                                  color: Colors.red),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // child: Image.network(
                                          //   //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                          //   'http://192.168.0.106:4040${state.uploadResponse['data']['cover_image']}',
                                          //   // it should load it because we are not in null state
                                          //   fit: BoxFit.cover,
                                          // ),
                                        );
                                      }
                                      return Container(
                                        height: device_height * 0.5,
                                        width: device_width,
                                        child: teacher[
                                                    'teacher_backGround_image'] ==
                                                null
                                            ? Image.asset(
                                                //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                                'assets/images/logo/icons8_user_500px.png',
                                                fit: BoxFit.cover,
                                              )
                                            // : Image.network(
                                            //     //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                            //     'http://192.168.0.106:4040${userState.data['cover_image']}',
                                            //     // it should load it because we are not in null state
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserProfileImagePreviewer(
                                                        path:
                                                            'http://192.168.0.106:4040${teacher['teacher_backGround_image']}',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: OctoImage(
                                                  image: CachedNetworkImageProvider(
                                                      'http://192.168.0.106:4040${teacher['teacher_backGround_image']}'),
                                                  placeholderBuilder:
                                                      OctoPlaceholder.blurHash(
                                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                  ),
                                                  errorBuilder: OctoError.icon(
                                                      color: Colors.red),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      );
                                    },
                                    listener: (context, state) {
                                      if (state is UploadedImage) {
                                        //! update Teacher Screen after upload the image
                                        BlocProvider.of<TeacherdataBloc>(
                                                context)
                                            .add(
                                          FetchTeacherData(
                                              userToken:
                                                  teacherToken ?? 'no token'),
                                        );
                                      }
                                      //! put default screen if no upload
                                    },
                                  )
                                : BlocConsumer<UseruploadimagesutilsblocBloc,
                                    UseruploadimagesutilsblocState>(
                                    builder: (context, state) {
                                      if (state is LoadingUploadImageProcess) {
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          child: LoadingIndicator(
                                            color: Color(0xff283C63),
                                            indicatorType:
                                                Indicator.ballRotateChase,
                                          ),
                                        );
                                      } else if (state is UploadedImage) {
                                        //fetch the url and use it here
                                        print(state.uploadResponse);
                                        return Container(
                                          height: device_height * 0.5,
                                          width: device_width,
                                          // child: Image.network(
                                          //   //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                          //   'http://192.168.0.106:4040${state.uploadResponse['data']['cover_image']}',
                                          //   // it should load it because we are not in null state
                                          //   fit: BoxFit.cover,
                                          // ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileImagePreviewer(
                                                    path:
                                                        'http://192.168.0.106:4040${teacher['teacher_backGround_image']}',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  'http://192.168.0.106:4040${teacher['teacher_backGround_image']}'),
                                              placeholderBuilder:
                                                  OctoPlaceholder.blurHash(
                                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                              ),
                                              errorBuilder: OctoError.icon(
                                                  color: Colors.red),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }
                                      //if no state yet released the we will use that one default from the userState initial
                                      return Container(
                                        height: device_height * 0.5,
                                        width: device_width,
                                        // child: Image.network(
                                        //   //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                        //   'http://192.168.0.106:4040${userState.data['cover_image']}',
                                        //   // it should load it because we are not in null state
                                        //   fit: BoxFit.cover,
                                        // ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfileImagePreviewer(
                                                  path:
                                                      'http://192.168.0.106:4040${teacher['teacher_backGround_image']}',
                                                ),
                                              ),
                                            );
                                          },
                                          child: OctoImage(
                                            image: CachedNetworkImageProvider(
                                                'http://192.168.0.106:4040${teacher['teacher_backGround_image']}'),
                                            placeholderBuilder:
                                                OctoPlaceholder.blurHash(
                                              'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                            ),
                                            errorBuilder: OctoError.icon(
                                                color: Colors.red),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    listener: (context, state) {
                                      if (state is UploadedImage) {
                                        //! update user Screen after teacher Upload image
                                        BlocProvider.of<TeacherdataBloc>(
                                                context)
                                            .add(
                                          FetchTeacherData(
                                              userToken:
                                                  teacherToken ?? 'no token'),
                                        );
                                      }
                                      //! put a current state if no upload
                                    },
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -device_height * 0.065,
                          child: Container(
                            height: device_height * 0.31,
                            width: device_height * 0.31,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -device_height * 0.05,
                          child: Container(
                            height: device_height * 0.28,
                            width: device_height * 0.28,
                            // color: Colors.black,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: (teacher['teacher_profile_image'] == null)
                                  ? BlocConsumer<UseruploadimagesutilsblocBloc,
                                      UseruploadimagesutilsblocState>(
                                      builder: (context, state) {
                                        if (state
                                            is LoadingUploadProfileImageProcess) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            height: 50,
                                            width: 50,
                                            child: LoadingIndicator(
                                              color: Color(0xff283C63),
                                              indicatorType:
                                                  Indicator.ballRotateChase,
                                            ),
                                          );
                                        } else if (state
                                            is UploadedProfileImageSuccessfully) {
                                          //fetch the url and use it here
                                          print(state.uploadResponse);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileImagePreviewer(
                                                    path:
                                                        'http://192.168.0.106:4040${teacher['teacher_profile_image']}',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  'http://192.168.0.106:4040${teacher['teacher_profile_image']}'),
                                              imageBuilder: OctoImageTransformer
                                                  .circleAvatar(),
                                              fit: BoxFit.cover,
                                              errorBuilder: OctoError.icon(
                                                  color: Colors.red),
                                            ),
                                          );
                                          // CircleAvatar(
                                          //   radius: device_height * 0.25,
                                          //   backgroundImage: Image.network(
                                          //     //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                          //     'http://192.168.0.106:4040${state.uploadResponse['data']['profile_image']}',
                                          //     // it should load it because we are not in null state
                                          //     fit: BoxFit.cover,
                                          //   ).image,
                                          // );
                                        }
                                        //if no state yet released the we will use that one default from the userState initial
                                        return CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: device_height * 0.25,
                                          backgroundImage: (teacher[
                                                      'teacher_profile_image'] ==
                                                  null)
                                              ? Image.asset(
                                                      'assets/images/logo/icons8_user_500px.png')
                                                  .image
                                              : Image.network(
                                                  //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                                  'http://192.168.0.106:4040${teacher['teacher_profile_image']}',
                                                  // it should load it because we are not in null state
                                                  fit: BoxFit.cover,
                                                ).image,
                                        );
                                      },
                                      listener: (context, state) {
                                        if (state
                                            is UploadedProfileImageSuccessfully) {
                                          //! update the screen after teacher upload the image
                                          BlocProvider.of<TeacherdataBloc>(
                                                  context)
                                              .add(
                                            FetchTeacherData(
                                                userToken:
                                                    teacherToken ?? 'no token'),
                                          );
                                        }
                                        //! push default
                                      },
                                    )
                                  : BlocConsumer<UseruploadimagesutilsblocBloc,
                                      UseruploadimagesutilsblocState>(
                                      builder: (context, state) {
                                        if (state
                                            is LoadingUploadProfileImageProcess) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            height: 50,
                                            width: 50,
                                            child: LoadingIndicator(
                                              color: Color(0xff283C63),
                                              indicatorType:
                                                  Indicator.ballRotateChase,
                                            ),
                                          );
                                        } else if (state
                                            is UploadedProfileImageSuccessfully) {
                                          //fetch the url and use it here
                                          //if uploaded successfully :
                                          print(state.uploadResponse);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileImagePreviewer(
                                                    path:
                                                        'http://192.168.0.106:4040${teacher['teacher_profile_image']}',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  'http://192.168.0.106:4040${teacher['teacher_profile_image']}'),
                                              imageBuilder: OctoImageTransformer
                                                  .circleAvatar(),
                                              fit: BoxFit.cover,
                                              errorBuilder: OctoError.icon(
                                                  color: Colors.red),
                                            ),
                                          );

                                          // CircleAvatar(
                                          //   radius: device_height * 0.25,
                                          //   backgroundImage: Image.network(
                                          //     //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                          //     'http://192.168.0.106:4040${state.uploadResponse['data']['profile_image']}',
                                          //     // it should load it because we are not in null state
                                          //     fit: BoxFit.cover,
                                          //   ).image,
                                          // );
                                        }
                                        //if no state yet released the we will use that one default from the userState initial
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfileImagePreviewer(
                                                  path:
                                                      'http://192.168.0.106:4040${teacher['teacher_profile_image']}',
                                                ),
                                              ),
                                            );
                                          },
                                          child: OctoImage(
                                            image: CachedNetworkImageProvider(
                                                'http://192.168.0.106:4040${teacher['teacher_profile_image']}'),
                                            imageBuilder: OctoImageTransformer
                                                .circleAvatar(),
                                            fit: BoxFit.cover,
                                            errorBuilder: OctoError.icon(
                                                color: Colors.red),
                                          ),
                                        );
                                        // CircleAvatar(
                                        //   backgroundColor: Colors.white,
                                        //   radius: device_height * 0.25,
                                        //   backgroundImage: Image.network(
                                        //     //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                        //     'http://192.168.0.106:4040${userState.data['profile_image']}',
                                        //     // it should load it because we are not in null state
                                        //     fit: BoxFit.cover,
                                        //   ).image,
                                        // );
                                      },
                                      listener: (context, state) {
                                        if (state
                                            is UploadedProfileImageSuccessfully) {
                                          //! update teacher screen

                                          BlocProvider.of<TeacherdataBloc>(
                                                  context)
                                              .add(FetchTeacherData(
                                                  userToken: teacherToken ??
                                                      'no token'));
                                        }
                                        //! put a default one
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    //TODO ADJUST THIS BECAUSE IT WILL MESSUP FROM DEVICE TO DEVICE
                    height: device_height * 0.1,
                    // color: Colors.amber,
                    child: Text(
                      teacher['user_information']['user_name'],
                      style: GoogleFonts.montserrat(
                        fontSize: device_height * 0.030,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.amber,
                    width: device_width,
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: Container(
                        height: device_height * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ApplicationColors
                              .getApplicationRecommendedBackgroundColor(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              width: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ApplicationColors.getActiveIconColor(),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.message_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Container(
                              height: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              width: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ApplicationColors.getActiveIconColor(),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.list_alt_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // ! go to proper screen
                                },
                              ),
                            ),
                            Container(
                              height: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              width: deviceOrientation == Orientation.portrait
                                  ? 10.h
                                  : 15.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ApplicationColors.getActiveIconColor(),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color:
                                            ApplicationColors.tryThsColorTwo(),
                                        alignment: Alignment.center,
                                        height: device_height,
                                        width: device_width * 0.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: device_width * 0.4,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  //!Profile Image Upload
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'choose Option'),
                                                        content: Container(
                                                          height: deviceOrientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? 30.h
                                                              : 100.w,
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  //camera path
                                                                  print(
                                                                      'upload profile image');
                                                                  try {
                                                                    final pickedImage =
                                                                        await picker
                                                                            .getImage(
                                                                      source: ImageSource
                                                                          .camera,
                                                                      // imageQuality:
                                                                      //     100, // the quality from 0 to 100
                                                                      maxHeight:
                                                                          device_height,

                                                                      maxWidth:
                                                                          device_height,
                                                                    );
                                                                    imageFile =
                                                                        pickedImage!;
                                                                    file = File(
                                                                        imageFile
                                                                            .path);
                                                                    print(
                                                                        userImagesData);
                                                                    userImagesData[
                                                                            'user_profile_image_file'] =
                                                                        pickedImage
                                                                            .path;
                                                                    print(
                                                                        userImagesData);
                                                                    // userImagesData[
                                                                    //         'user_profile_imageFile'] =
                                                                    //     imageFile
                                                                    //         .path;
                                                                    userImagesData[
                                                                            'user_token'] =
                                                                        teacherToken;
                                                                    // Console.log(
                                                                    //     userImagesData);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    BlocProvider.of<UseruploadimagesutilsblocBloc>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .add(
                                                                      UploadImage(
                                                                          data:
                                                                              userImagesData,
                                                                          uploadChoice:
                                                                              UserUploadEnumsUtils.UploadProfileImage),
                                                                    );
                                                                  } catch (error) {
                                                                    print(
                                                                        error);
                                                                    pickImageError =
                                                                        error; // wow i love flutter
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                    Icons
                                                                        .camera),
                                                                title: Text(
                                                                    'Camera'),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  //gallery path
                                                                  print(
                                                                      'profile camera image upload from gallery');
                                                                  try {
                                                                    final pickedImage =
                                                                        await picker
                                                                            .getImage(
                                                                      source: ImageSource
                                                                          .gallery,
                                                                      // imageQuality:
                                                                      //     100,
                                                                      maxHeight:
                                                                          device_height,

                                                                      maxWidth:
                                                                          device_height,
                                                                    );
                                                                    imageFile =
                                                                        pickedImage!;
                                                                    file = File(
                                                                        imageFile
                                                                            .path);
                                                                    //! or here the data will travel
                                                                    print(
                                                                        userImagesData);
                                                                    userImagesData[
                                                                            'user_profile_image_file'] =
                                                                        pickedImage
                                                                            .path;
                                                                    print(
                                                                        userImagesData);
                                                                    // userImagesData[
                                                                    //         'user_profile_imageFile'] =
                                                                    //     imageFile
                                                                    //         .path;
                                                                    userImagesData[
                                                                            'user_token'] =
                                                                        teacherToken;
                                                                    // Console.log(
                                                                    //     userImagesData);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    BlocProvider.of<UseruploadimagesutilsblocBloc>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .add(UploadImage(
                                                                            data:
                                                                                userImagesData,
                                                                            uploadChoice:
                                                                                UserUploadEnumsUtils.UploadProfileImage));
                                                                  } catch (error) {
                                                                    print(
                                                                        error);
                                                                    pickImageError =
                                                                        error; // wow i love flutter
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                    Icons
                                                                        .image),
                                                                title: Text(
                                                                    'Gallery'),
                                                              ),
                                                              ListTile(
                                                                leading: Icon(Icons
                                                                    .arrow_back),
                                                                title: Text(
                                                                    'Cancel'),
                                                                onTap: () {
                                                                  Console.log(
                                                                      'cancel the process');
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                                ),
                                                child: Text(
                                                  'update Profile Image',
                                                  style: TextStyle(
                                                    fontSize:
                                                        deviceOrientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? 10.sp
                                                            : 15.sp,
                                                    color: ApplicationColors
                                                        .getActiveIconColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: device_height * 0.025,
                                            ),
                                            Container(
                                              width: device_width * 0.4,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  //! cover Phone Upload
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'choose Option'),
                                                        content: Container(
                                                          height:
                                                              device_height *
                                                                  0.28,
                                                          // width: 200,
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  //camera path
                                                                  Console.log(
                                                                      'profile camera image upload');
                                                                  try {
                                                                    final pickedImage =
                                                                        await picker
                                                                            .getImage(
                                                                      source: ImageSource
                                                                          .camera,
                                                                      // imageQuality:
                                                                      //     100,
                                                                      maxHeight:
                                                                          device_height,

                                                                      maxWidth:
                                                                          device_width,
                                                                    );
                                                                    print(pickedImage!
                                                                        .path);
                                                                    print(
                                                                        userImagesData);
                                                                    userImagesData[
                                                                            'user_cover_image_file'] =
                                                                        pickedImage
                                                                            .path;
                                                                    print(
                                                                        userImagesData);
                                                                    // userImagesData[
                                                                    //         'user_profile_imageFile'] =
                                                                    //     imageFile
                                                                    //         .path;
                                                                    userImagesData[
                                                                            'user_token'] =
                                                                        teacherToken;
                                                                    // Console.log(
                                                                    //     userImagesData);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    BlocProvider.of<UseruploadimagesutilsblocBloc>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .add(UploadImage(
                                                                            data:
                                                                                userImagesData,
                                                                            uploadChoice:
                                                                                UserUploadEnumsUtils.UploadCoverImage));
                                                                  } catch (error) {
                                                                    pickImageError =
                                                                        error; // wow i love flutter
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                    Icons
                                                                        .camera),
                                                                title: Text(
                                                                    'Camera'),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  //gallery path
                                                                  Console.log(
                                                                      'profile camera image upload from gallery');
                                                                  try {
                                                                    final pickedImage =
                                                                        await picker
                                                                            .getImage(
                                                                      source: ImageSource
                                                                          .gallery,
                                                                      // imageQuality:
                                                                      //     100,
                                                                      maxHeight:
                                                                          device_height,

                                                                      maxWidth:
                                                                          device_width,
                                                                    );
                                                                    print(pickedImage!
                                                                        .path);
                                                                    print(
                                                                        userImagesData);
                                                                    userImagesData[
                                                                            'user_cover_image_file'] =
                                                                        pickedImage
                                                                            .path;
                                                                    print(
                                                                        userImagesData);
                                                                    // userImagesData[
                                                                    //         'user_profile_imageFile'] =
                                                                    //     imageFile
                                                                    //         .path;
                                                                    userImagesData[
                                                                            'user_token'] =
                                                                        teacherToken;
                                                                    // Console.log(
                                                                    //     userImagesData);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    BlocProvider.of<UseruploadimagesutilsblocBloc>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .add(UploadImage(
                                                                            data:
                                                                                userImagesData,
                                                                            uploadChoice:
                                                                                UserUploadEnumsUtils.UploadCoverImage));
                                                                  } catch (error) {
                                                                    pickImageError =
                                                                        error; // wow i love flutter
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                    Icons
                                                                        .image),
                                                                title: Text(
                                                                    'Gallery'),
                                                              ),
                                                              ListTile(
                                                                leading: Icon(Icons
                                                                    .arrow_back),
                                                                title: Text(
                                                                    'Cancel'),
                                                                onTap: () {
                                                                  Console.log(
                                                                      'cancel the process');
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                                ),
                                                child: Text(
                                                  'update cover Image',
                                                  style: TextStyle(
                                                    fontSize:
                                                        deviceOrientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? 10.sp
                                                            : 15.sp,
                                                    color: ApplicationColors
                                                        .getActiveIconColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//****/

class GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 100,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 2,
            margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
          )
        ],
      ),
    );
  }
}

_accountStateHelper(int accountState) {
  switch (accountState) {
    case 1:
      //some code
      return Image.asset(
          'assets/images/logo/icons8_verified_account_480px.png');

    case 2:
      //some code
      return Container(
        height: 40,
        width: 40,
        child: Image.asset('assets/images/logo/icons8_no_entry_512px.png'),
      );
    case 3:
      //some code
      return Container(
        height: 40,
        width: 40,
        child: Image.asset('assets/images/logo/icons8_no_entry_512px.png'),
      );
    case 4:
      //some code
      return Container(
        height: 40,
        width: 40,
        child: Image.asset('assets/images/logo/icons8_no_entry_512px.png'),
      );
    default:
      return Container();
  }
}

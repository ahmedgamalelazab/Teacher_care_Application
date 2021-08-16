import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../auth/app_auth_screen.dart';
import '../../../../application_colors/application_colors.dart';
import '../../../../database/internalRepository/authDataBaseRepository.dart';
import 'usersDetailedScreen/admin_moderators_detailed_screen.dart';
import 'usersDetailedScreen/admin_parents_detailed_screen.dart';
import 'usersDetailedScreen/admin_students_detailed_screen.dart';
import 'usersDetailedScreen/admin_teachers_detailed_screen.dart';
import '../../auth/app_log_out_screen.dart';
import '../../../../server/logic/userControlScreenBloc/userutilscontrolscreen_bloc.dart';

import '../../../../server/logic/UserUploadFilesBloc/useruploadimagesutilsbloc_bloc.dart';
import '../../../../server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';
import '../../../../utils/js/js_console_log.dart';
import '../../../componets/constant/userUploadImagesUtils.dart';
// import 'adminPatchBio.dart';
import 'admin_edit_screen.dart';

import '../../../../system_src/objectsSrc.dart';

import 'package:widget_circular_animator/widget_circular_animator.dart';

//section of nav bar
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

//displaying application Images
import 'package:octo_image/octo_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

//sliding panales
import 'package:snapping_sheet/snapping_sheet.dart';

// i will connect this screen with the bloc to obtain the latest state from the bloc and after that i will
//create the bloc and continue the profile work up to finish it all
/*
  ? the upload images plan : 
  * we will make the screen responsible of taking the images from storage or from the camera ✅
  * this screen will store the date in a file ✅
  * this screen will after send this image to a bloc ✅
  * the bloc will take the file path and will connect to the data base ✅
  * the data base will take the file and store it in the internal storage ✅
  * the server will response back with the image location that had already hashed in the database ✅
  * the screen will fetch the image from the server by loading it from the path ✅
  ! if the user try in anytime to upload another image the server have to delete the latest one and after that i will
  ! the server after deleting the latest image , now the server can simply receive any other image again
 */

//this but i will take some time off and i will come back fix this bug brb

class Admin_profile_screen extends StatefulWidget {
  static const String SCREEN_ROUTE = '/Admin_profile_screen';
  const Admin_profile_screen({Key? key}) : super(key: key);

  @override
  _Admin_profile_screenState createState() => _Admin_profile_screenState();
}

class _Admin_profile_screenState extends State<Admin_profile_screen>
    with TickerProviderStateMixin {
  dynamic profileInitState;
  dynamic userState;
  dynamic userToken;
  dynamic user_role;
  dynamic userId;
  int begin = 0;
  //hashing the screen into numbers then call a splitter function
  int currentIndex = 0;
  Map<String, int> controlScreens = {
    "currentIndex": 0,
  };

  void switchScreenFromButtons(int index) {
    setState(() {
      currentIndex = index;
      tabController.index = index;
    });
  }

  //section of take images dependencies
  dynamic _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = new ImagePicker();
  dynamic _file;
  dynamic backgroundImageFile;
  //end of take images dependencies

  // @override
  // void initState() {
  //   _testInternalDataBase();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // this code will get read only once

    if (begin == 0) {
      // fetching user data from the last state emitted from the application and this state will be diff from user to another user
      profileInitState =
          BlocProvider.of<UserAuthBlocBloc>(context, listen: false).state;
      userToken = profileInitState.data['token'];
      userId = profileInitState.data['admin_id'];
      user_role = profileInitState.data['user_role'];
      print(userToken);
      print(user_role);
      print(userId);
      BlocProvider.of<UserAuthBlocBloc>(context, listen: false)
          .add(UpdateUserDataAfterLogin(userToken: userToken));
      userState =
          BlocProvider.of<UserAuthBlocBloc>(context, listen: false).state;

      begin++;
    }
    super.didChangeDependencies();
  }

  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //under any refresh i will reinitialize this userState
    final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
    Console.log(device_width);
    Console.log(currentIndex);
    return Scaffold(
      backgroundColor:
          ApplicationColors.getApplicationRecommendedBackgroundColor(),
      bottomNavigationBar: ConvexAppBar(
        controller: tabController,
        // height: device_height * 0.2,
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
        initialActiveIndex: 0,

        onTap: (index) {
          setState(() {
            //change the index and update the screen latest from the server side
            currentIndex = index;
            controlScreens['currentIndex'] = index;
            BlocProvider.of<UserAuthBlocBloc>(context, listen: false)
                .add(UpdateUserDataAfterLogin(userToken: userToken));
            userState =
                BlocProvider.of<UserAuthBlocBloc>(context, listen: false).state;
            Console.log('calling from state');
            print(userState.data);
          });
        },
      ),
      body: _screens_branching(
          currentIndex,
          device_height,
          device_width,
          userState,
          context,
          _imageFile,
          _picker,
          _pickImageError,
          _file,
          backgroundImageFile,
          userToken,
          userId,
          user_role,
          controlScreens, // pass by reference
          switchScreenFromButtons),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

_screens_branching(
  int currentIndex,
  double deviceHeight,
  double deviceWidth,
  dynamic userState,
  BuildContext context,
  dynamic image_file,
  ImagePicker picker,
  dynamic pickImageError,
  dynamic file,
  dynamic backgroundImageFile,
  dynamic userToken,
  dynamic userId,
  dynamic user_role,
  Map<String, int> controlScreen,
  void Function(int num) switchScreens,
) {
  switch (currentIndex) {
    case 0:
      return AdminProfileScreen(
        currentIndex: currentIndex,
        deviceHeight: deviceHeight,
        deviceWidth: deviceWidth,
        userState: userState,
        context: context,
        file: file,
        image_file: image_file,
        pickImageError: pickImageError,
        picker: picker,
        backgroundImageFile: backgroundImageFile,
        userToken: userToken,
        userId: userId,
        user_role: user_role,
        controlScreen: controlScreen,
        switchScreens: switchScreens,
      );
    case 1:
      // this screen should design the dash board for our application
      // i will use grid view to contain the application objects
      return AdminDashBoardScreen(
        userToken: userToken,
      );
    case 2:
      //will be coded later
      return AdminSettingsScreen();
    default:
      // on error or any secure point we will code a screen here
      return Container(
        child: Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
  }
}

//TODO TAKE THE WHOLE ENTIRE THING AND THROUGH IT AWAY FROM HERE
class AdminProfileScreen extends StatefulWidget {
  AdminProfileScreen({
    Key? key,
    required this.currentIndex,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.userState,
    required this.context,
    required this.image_file,
    required this.picker,
    required this.pickImageError,
    required this.file,
    required this.backgroundImageFile,
    required this.userToken,
    required this.userId,
    required this.user_role,
    required this.controlScreen,
    required this.switchScreens,
  }) : super(key: key);

  int currentIndex;
  double deviceHeight;
  double deviceWidth;
  dynamic userState;
  BuildContext context;
  dynamic image_file;
  ImagePicker picker;
  dynamic pickImageError;
  dynamic file;
  dynamic backgroundImageFile;
  dynamic userToken;
  dynamic userId;
  dynamic user_role;
  Map<String, int> controlScreen;
  void Function(int num) switchScreens;
  // i will map the date from this profile to the backend server to allow the server to use this data and do this things
  // the server will take the date normally and will start to take the id of the user and generate a folder written with his name
  // every body on the server will have a folder and each folder will contain the cover image or the profile image
  // both of the folders will remove this data once the user try to upload another piece and so on

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState(
        context: context,
        currentIndex: currentIndex,
        deviceHeight: deviceHeight,
        deviceWidth: deviceWidth,
        file: file,
        image_file: image_file,
        picker: picker,
        pickImageError: pickImageError,
        userState: userState,
        backgroundImageFile: backgroundImageFile,
        userToken: userToken,
        userId: userId,
        user_role: user_role,
        controlScreen: controlScreen,
        switchScreens: switchScreens,
      );
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  _AdminProfileScreenState({
    required this.currentIndex,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.userState,
    required this.context,
    required this.image_file,
    required this.picker,
    required this.pickImageError,
    required this.file,
    required this.backgroundImageFile,
    required this.userToken,
    required this.userId,
    required this.user_role,
    required this.controlScreen,
    required this.switchScreens,
  });

  int currentIndex;
  double deviceHeight;
  double deviceWidth;
  dynamic userState;
  BuildContext context;
  dynamic image_file;
  ImagePicker picker;
  dynamic pickImageError;
  dynamic file; // the file here is the profile file
  dynamic backgroundImageFile;
  dynamic userToken;
  dynamic userBioTraversed;
  dynamic userId;
  dynamic user_role;
  Map<String, int> controlScreen;
  void Function(int num) switchScreens;
  bool internalDataInserted = false;

  _isUserInsertedBefore() async {
    try {
      final response =
          await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
              .fetchUserDataIfExistsInMyDataBase(userId: userId);
      //check for the storage if it's empty or not
      if (response.length != 0) {
        print(response);
        if (response[0]['userId'] == userId) {
          internalDataInserted = true;
          print('done sir');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  //before inserting data i will have to check if i inserted before or not
  _initializeInternalDataWithUserToken() async {
    try {
      final insertionInternalResponse =
          await RepositoryProvider.of<AuthInternalDataBaseRepository>(context)
              .insertDataInternally(data: {
        'user_id': userId,
        'user_token': userToken,
        'user_role': user_role,
      });
      //if all are ok
      print('data inserted internally well');
      print(insertionInternalResponse);
    } catch (error) {
      print(error);
    }
  }

  _insertDataInQuee() async {
    await _isUserInsertedBefore();
    if (internalDataInserted == false) {
      await _initializeInternalDataWithUserToken();
    }
  }

  final snappingSheetController = SnappingSheetController();
  Map<String, dynamic> userImagesData = {
    "user_token":
        "", //user id here mention the user child role not the parent user id
    "user_profile_image_file": "",
    "user_cover_image_file": "",
  };

  @override
  void initState() {
    _insertDataInQuee();
    // _initializeInternalDataWithUserToken(); not now
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
    // Console.log(userState.data);
    Console.log(currentIndex);
    Console.log(controlScreen['currentIndex']);

    return Scaffold(
      backgroundColor:
          ApplicationColors.getApplicationRecommendedBackgroundColor(),
      body: SnappingSheet(
        lockOverflowDrag: true, // (Recommended) Set this to true.
        controller: snappingSheetController,
        grabbing: GrabbingWidget(),
        grabbingHeight: 75,
        sheetBelow: SnappingSheetContent(
          draggable: false,
          // TODO: Add your sheet content here
          child: Scaffold(
            // height: device_height * 0.5,
            // color: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    width: device_width,
                    height: device_width * 0.1,
                    color: ApplicationColors.tryThsColorTwo(),
                    child: Text(
                      'Account State',
                      style: GoogleFonts.montserrat(
                        fontSize: device_height * 0.020,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: device_height * 0.02),
                  Container(
                    width: device_width,
                    alignment: Alignment.center,
                    child: WidgetCircularAnimator(
                      size: device_width * 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                        child: _accountStateHelper(
                            userState.data['admin_account_state']),
                      ),
                    ),
                  ),
                  SizedBox(height: device_height * 0.02),
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    width: device_width,
                    height: device_width * 0.1,
                    color: ApplicationColors.tryThsColorTwo(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'user Bio',
                          style: GoogleFonts.montserrat(
                            fontSize: device_height * 0.020,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Console.log('edit this bio');
                                Navigator.of(context).pushNamed(
                                    PatchUserBioScreen.SCREEN_ROUTE,
                                    arguments: {
                                      "user_bio": userBioTraversed ??
                                          'No User Bio added yet',
                                      "token": userToken,
                                    }).then(
                                  (_) => Future.value(
                                    [
                                      BlocProvider.of<UserAuthBlocBloc>(context,
                                              listen: false)
                                          .add(
                                        UpdateUserDataAfterLogin(
                                            userToken: userToken),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: device_height * 0.02),
                  //!user Bio
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(
                      left: device_width * 0.050,
                      right: device_width * 0.050,
                      bottom: device_width * 0.050,
                    ),
                    child: Card(
                      elevation: 5,
                      color: Color(0xFFFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.all(device_height * 0.025),
                        child:
                            BlocConsumer<UserAuthBlocBloc, UserAuthBlocState>(
                          builder: (context, state) {
                            if (state is LoadedUserUpdateProfileData) {
                              userBioTraversed = state.data['admin_bio'];
                              return Text(
                                state.data['admin_bio'] ??
                                    'No User Bio Added Yet',
                                style: GoogleFonts.montserrat(
                                  fontSize: device_height * 0.020,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                              );
                            }
                            userBioTraversed = userState.data['admin_bio'];
                            return Text(
                              userState.data['admin_bio'] ??
                                  'No User Bio Added Yet',
                              style: GoogleFonts.montserrat(
                                fontSize: device_height * 0.020,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            );
                          },
                          listener: (context, state) {},
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    width: device_width,
                    height: device_width * 0.1,
                    color: ApplicationColors.tryThsColorTwo(),
                    child: Text(
                      'Account details',
                      style: GoogleFonts.montserrat(
                        fontSize: device_height * 0.020,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: device_height * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User Email',
                          style: GoogleFonts.montserrat(
                            fontSize: device_height * 0.020,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userState.data['admin_email'],
                          style: GoogleFonts.montserrat(
                            fontSize: device_height * 0.020,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: device_height * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User Role',
                          style: GoogleFonts.montserrat(
                            fontSize: device_height * 0.020,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userState.data['user_role'],
                          style: GoogleFonts.montserrat(
                            fontSize: device_height * 0.020,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ),
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
                            child: userState.data['cover_image'] == null
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
                                          child: OctoImage(
                                            image: CachedNetworkImageProvider(
                                                'http://192.168.0.106:4040${state.uploadResponse['data']['cover_image']}'),
                                            placeholderBuilder:
                                                OctoPlaceholder.blurHash(
                                              'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                            ),
                                            errorBuilder: OctoError.icon(
                                                color: Colors.red),
                                            fit: BoxFit.cover,
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
                                        child: userState.data['cover_image'] ==
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
                                            : OctoImage(
                                                image: CachedNetworkImageProvider(
                                                    'http://192.168.0.106:4040${userState.data['cover_image']}'),
                                                placeholderBuilder:
                                                    OctoPlaceholder.blurHash(
                                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                ),
                                                errorBuilder: OctoError.icon(
                                                    color: Colors.red),
                                                fit: BoxFit.cover,
                                              ),
                                      );
                                    },
                                    listener: (context, state) {
                                      if (state is UploadedImage) {
                                        BlocProvider.of<UserAuthBlocBloc>(
                                                context,
                                                listen: false)
                                            .add(UpdateUserDataAfterLogin(
                                                userToken: userToken));
                                      }
                                      BlocProvider.of<UserAuthBlocBloc>(context,
                                              listen: false)
                                          .add(UpdateUserDataAfterLogin(
                                              userToken: userToken));
                                      userState =
                                          BlocProvider.of<UserAuthBlocBloc>(
                                                  context,
                                                  listen: false)
                                              .state;
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
                                          child: OctoImage(
                                            image: CachedNetworkImageProvider(
                                                'http://192.168.0.106:4040${state.uploadResponse['data']['cover_image']}'),
                                            placeholderBuilder:
                                                OctoPlaceholder.blurHash(
                                              'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                            ),
                                            errorBuilder: OctoError.icon(
                                                color: Colors.red),
                                            fit: BoxFit.cover,
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
                                        child: OctoImage(
                                          image: CachedNetworkImageProvider(
                                              'http://192.168.0.106:4040${userState.data['cover_image']}'),
                                          placeholderBuilder:
                                              OctoPlaceholder.blurHash(
                                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                          ),
                                          errorBuilder:
                                              OctoError.icon(color: Colors.red),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    listener: (context, state) {
                                      if (state is UploadedImage) {
                                        BlocProvider.of<UserAuthBlocBloc>(
                                                context,
                                                listen: false)
                                            .add(UpdateUserDataAfterLogin(
                                                userToken: userToken));
                                      }
                                      BlocProvider.of<UserAuthBlocBloc>(context,
                                              listen: false)
                                          .add(UpdateUserDataAfterLogin(
                                              userToken: userToken));
                                      userState =
                                          BlocProvider.of<UserAuthBlocBloc>(
                                                  context,
                                                  listen: false)
                                              .state;
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
                              child: (userState.data['profile_image'] == null)
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
                                          return OctoImage(
                                            image: CachedNetworkImageProvider(
                                                'http://192.168.0.106:4040${state.uploadResponse['data']['profile_image']}'),
                                            imageBuilder: OctoImageTransformer
                                                .circleAvatar(),
                                            fit: BoxFit.cover,
                                            errorBuilder: OctoError.icon(
                                                color: Colors.red),
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
                                          backgroundImage: (userState
                                                      .data['profile_image'] ==
                                                  null)
                                              ? Image.asset(
                                                      'assets/images/logo/icons8_user_500px.png')
                                                  .image
                                              : Image.network(
                                                  //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                                  'http://192.168.0.106:4040${userState.data['profile_image']}',
                                                  // it should load it because we are not in null state
                                                  fit: BoxFit.cover,
                                                ).image,
                                        );
                                      },
                                      listener: (context, state) {
                                        if (state
                                            is UploadedProfileImageSuccessfully) {
                                          BlocProvider.of<UserAuthBlocBloc>(
                                                  context,
                                                  listen: false)
                                              .add(UpdateUserDataAfterLogin(
                                                  userToken: userToken));
                                        }
                                        BlocProvider.of<UserAuthBlocBloc>(
                                                context,
                                                listen: false)
                                            .add(UpdateUserDataAfterLogin(
                                                userToken: userToken));
                                        userState =
                                            BlocProvider.of<UserAuthBlocBloc>(
                                                    context,
                                                    listen: false)
                                                .state;
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
                                          print(state.uploadResponse);
                                          return GestureDetector(
                                            onTap: () {
                                              print('upload image');
                                            },
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  'http://192.168.0.106:4040${state.uploadResponse['data']['profile_image']}'),
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
                                        return OctoImage(
                                          image: CachedNetworkImageProvider(
                                              'http://192.168.0.106:4040${userState.data['profile_image']}'),
                                          imageBuilder: OctoImageTransformer
                                              .circleAvatar(),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              OctoError.icon(color: Colors.red),
                                        );
                                        // CircleAvatar(
                                        //   backgroundColor: Colors.white,
                                        //   radius: device_height * 0.25,
                                        //   backgroundImage: Image.network(
                                        //     //❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎❎
                                        //     'http://192.168.1.9:4040${userState.data['profile_image']}',
                                        //     // it should load it because we are not in null state
                                        //     fit: BoxFit.cover,
                                        //   ).image,
                                        // );
                                      },
                                      listener: (context, state) {
                                        if (state
                                            is UploadedProfileImageSuccessfully) {
                                          BlocProvider.of<UserAuthBlocBloc>(
                                                  context,
                                                  listen: false)
                                              .add(UpdateUserDataAfterLogin(
                                                  userToken: userToken));
                                        }
                                        BlocProvider.of<UserAuthBlocBloc>(
                                                context,
                                                listen: false)
                                            .add(UpdateUserDataAfterLogin(
                                                userToken: userToken));
                                        userState =
                                            BlocProvider.of<UserAuthBlocBloc>(
                                                    context,
                                                    listen: false)
                                                .state;
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
                      userState.data['admin_name'],
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
                              height: device_height * 0.090,
                              width: device_height * 0.090,
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
                              height: device_height * 0.090,
                              width: device_height * 0.090,
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
                                  switchScreens(1);
                                },
                              ),
                            ),
                            Container(
                              height: device_height * 0.090,
                              width: device_height * 0.090,
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
                                          color: ApplicationColors
                                              .tryThsColorTwo(),
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
                                                                        source:
                                                                            ImageSource.camera,
                                                                        imageQuality:
                                                                            100, // the quality from 0 to 100
                                                                        maxHeight:
                                                                            device_height *
                                                                                0.3,
                                                                        maxWidth:
                                                                            device_height *
                                                                                0.3,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        image_file =
                                                                            pickedImage!;
                                                                        file = File(
                                                                            image_file.path);
                                                                        //? data ready to travel from here also
                                                                        userImagesData['user_profile_image_file'] =
                                                                            image_file.path;
                                                                        userImagesData['user_token'] =
                                                                            userToken;
                                                                        Console.log(
                                                                            userImagesData);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      BlocProvider.of<UseruploadimagesutilsblocBloc>(context, listen: false).add(UploadImage(
                                                                          data:
                                                                              userImagesData,
                                                                          uploadChoice:
                                                                              UserUploadEnumsUtils.UploadProfileImage));
                                                                    } catch (error) {
                                                                      setState(
                                                                          () {
                                                                        pickImageError =
                                                                            error; // wow i love flutter
                                                                      });
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
                                                                        source:
                                                                            ImageSource.gallery,
                                                                        imageQuality:
                                                                            100,
                                                                        maxHeight:
                                                                            device_height *
                                                                                0.3,
                                                                        maxWidth:
                                                                            device_height *
                                                                                0.3,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        image_file =
                                                                            pickedImage!;
                                                                        file = File(
                                                                            image_file.path);
                                                                        //! or here the data will travel
                                                                        userImagesData['user_profile_image_file'] =
                                                                            image_file.path;
                                                                        userImagesData['user_token'] =
                                                                            userToken;
                                                                        Console.log(
                                                                            userImagesData);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      BlocProvider.of<UseruploadimagesutilsblocBloc>(context, listen: false).add(UploadImage(
                                                                          data:
                                                                              userImagesData,
                                                                          uploadChoice:
                                                                              UserUploadEnumsUtils.UploadProfileImage));
                                                                    } catch (error) {
                                                                      setState(
                                                                          () {
                                                                        pickImageError =
                                                                            error; // wow i love flutter
                                                                      });
                                                                    }
                                                                  },
                                                                  leading: Icon(
                                                                      Icons
                                                                          .image),
                                                                  title: Text(
                                                                      'Gallery'),
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
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
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'update Profile Image',
                                                    style: TextStyle(
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
                                                                        source:
                                                                            ImageSource.camera,
                                                                        imageQuality:
                                                                            100,
                                                                        maxHeight:
                                                                            deviceHeight *
                                                                                0.5,
                                                                        maxWidth:
                                                                            deviceWidth,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        image_file =
                                                                            pickedImage!;
                                                                        backgroundImageFile =
                                                                            File(image_file.path);
                                                                        //? here the data get ready to travel
                                                                        userImagesData['user_cover_image_file'] =
                                                                            image_file.path;
                                                                        userImagesData['user_token'] =
                                                                            userToken;
                                                                        Console.log(
                                                                            userImagesData);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      // all are ok
                                                                      BlocProvider.of<UseruploadimagesutilsblocBloc>(context, listen: false).add(UploadImage(
                                                                          data:
                                                                              userImagesData,
                                                                          uploadChoice:
                                                                              UserUploadEnumsUtils.UploadCoverImage));
                                                                    } catch (error) {
                                                                      setState(
                                                                          () {
                                                                        pickImageError =
                                                                            error; // wow i love flutter
                                                                      });
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
                                                                        source:
                                                                            ImageSource.gallery,
                                                                        imageQuality:
                                                                            100,
                                                                        maxHeight:
                                                                            device_height *
                                                                                0.5,
                                                                        maxWidth:
                                                                            device_width,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        image_file =
                                                                            pickedImage!;
                                                                        backgroundImageFile =
                                                                            File(image_file.path);
                                                                        //!or here the data will travel
                                                                        userImagesData['user_cover_image_file'] =
                                                                            image_file.path;
                                                                        userImagesData['user_token'] =
                                                                            userToken;
                                                                        Console.log(
                                                                            userImagesData);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      BlocProvider.of<UseruploadimagesutilsblocBloc>(context, listen: false).add(UploadImage(
                                                                          data:
                                                                              userImagesData,
                                                                          uploadChoice:
                                                                              UserUploadEnumsUtils.UploadCoverImage));
                                                                    } catch (error) {
                                                                      setState(
                                                                          () {
                                                                        pickImageError =
                                                                            error; // wow i love flutter
                                                                      });
                                                                    }
                                                                  },
                                                                  leading: Icon(
                                                                      Icons
                                                                          .image),
                                                                  title: Text(
                                                                      'Gallery'),
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
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
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'update cover Image',
                                                    style: TextStyle(
                                                      color: ApplicationColors
                                                          .getActiveIconColor(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
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
}

//################################################################# admin profile done #################################################################

//Admin control dash board design screen
// there's a bloc will be designed for this screen
class AdminDashBoardScreen extends StatefulWidget {
  static const String ScreenRoute = './AdminDashBoardScreen';
  AdminDashBoardScreen({Key? key, required this.userToken}) : super(key: key);
  final String userToken;

  @override
  _AdminDashBoardScreenState createState() =>
      _AdminDashBoardScreenState(userToken: userToken);
}

class _AdminDashBoardScreenState extends State<AdminDashBoardScreen> {
  //section of variables
  dynamic moderatorsTotalNumberInSystem;
  dynamic teachersTotalNumberInSystem;
  dynamic studentsTotalNumberInSystem;
  dynamic parentsTotalNumberInSystem;

  final String userToken;
  bool isInit = false;

  _AdminDashBoardScreenState({required this.userToken});

  @override
  Widget build(BuildContext context) {
    if (!isInit) {
      BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
        FetchUserScreenData(userToken: userToken),
      );
      isInit = true;
    }
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<UserutilscontrolscreenBloc,
        UserutilscontrolscreenState>(
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
          moderatorsTotalNumberInSystem =
              state.response['data']['total_moderators_in_system'];
          teachersTotalNumberInSystem =
              state.response['data']['total_teachers_in_system'];
          studentsTotalNumberInSystem =
              state.response['data']['total_students_in_system'];
          parentsTotalNumberInSystem =
              state.response['data']['total_parents_in_system'];
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                FetchUserScreenData(userToken: userToken),
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
                        _detectProperImageView(
                            'assets/images/moderator.jpg', index),
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
    );
  }

  //this function will control the InkWell direction
  _routeToUsersDetails(int index, BuildContext context) {
    switch (index) {
      //moderators details screen
      case 0:
        Navigator.of(context)
            .pushNamed(ModeratorDetailedScreenAdmin.ScreenRoute)
            .then(
                (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                      FetchUserScreenData(userToken: userToken),
                    ));
        break;
      // teachers details screen
      case 1:
        Navigator.of(context)
            .pushNamed(TeacherDetailedScreenAdmin.ScreenRoute)
            .then(
                (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                      FetchUserScreenData(userToken: userToken),
                    ));
        break;
      //students details screen
      case 2:
        Navigator.of(context)
            .pushNamed(StudentsDetailedScreenAdmin.ScreenRoute)
            .then(
                (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                      FetchUserScreenData(userToken: userToken),
                    ));
        break;
      //parents details screen
      case 3:
        Navigator.of(context)
            .pushNamed(ParentsDetailedScreenAdmin.ScreenRoute)
            .then(
              (_) => BlocProvider.of<UserutilscontrolscreenBloc>(context).add(
                FetchUserScreenData(userToken: userToken),
              ),
            );
        break;
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
              moderatorsTotalNumberInSystem.toString(),
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
              teachersTotalNumberInSystem.toString(),
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
              studentsTotalNumberInSystem.toString(),
              style: GoogleFonts.montserrat(
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: ApplicationColors.getHeaderFontsColor(),
              ),
            ),
          ),
        );
      case 3:
        return FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              parentsTotalNumberInSystem.toString(),
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
  _detectProperImageView(String imagePath, int index) {
    switch (index) {
      case 0:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/moderator.jpg',
            fit: BoxFit.cover,
          ),
        );
      case 1:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/teacher.jpeg',
            fit: BoxFit.cover,
          ),
        );
      case 2:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/students.jpg',
            fit: BoxFit.cover,
          ),
        );
      case 3:
        return Container(
          // color: Colors.red,
          child: Image.asset(
            'assets/images/parents.jpg',
            fit: BoxFit.cover,
          ),
        );
      default:
        return Container();
    }
  }
}

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

//global functions

//creating settings screen relative to admin

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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

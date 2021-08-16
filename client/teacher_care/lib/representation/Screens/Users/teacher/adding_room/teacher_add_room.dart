import 'package:dio/dio.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folding_menu/folding_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/server/logic/TeacherCreateRoom/teachercreatreroom_bloc.dart';
import 'package:teacher_care/server/logic/TeacherRegisterStudent/teacherregisterstudent_bloc.dart';

import '../teacher_add_student_loading.dart';

import 'package:sizer/sizer.dart';

import 'teacher_adding_room_loading.dart';

class TeacherAddRoomScreen extends StatefulWidget {
  static const String PAGE_ROUTE = './TeacherAddRoomScreen';
  TeacherAddRoomScreen({Key? key}) : super(key: key);

  @override
  _TeacherAddRoomScreenState createState() => _TeacherAddRoomScreenState();
}

class _TeacherAddRoomScreenState extends State<TeacherAddRoomScreen> {
  //end of force validation section
  //form controllers
  final _formKey = GlobalKey<FormState>();
  // bool _openMenu = false;
  // bool _openMenuSubjects = false;
  //FORM BODY will be sent in a map form not model forms
  Map<String, dynamic> formBody = {
    "room_title": "", //✅
    "room_bio": "", //✅
    "teacher_id": "",
    "video_conference_state": false,
  };
  //the whole implementations will change when we deal with the localizations
  ///when the application starts we will fetch all governorates from the server

  @override
  Widget build(BuildContext context) {
    print(formBody);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final clearHeight = deviceHeight - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //starting with the application logo
                  Container(
                    height: clearHeight * 0.30,
                    width: deviceWidth * 0.7,
                    child:
                        Image.asset('assets/images/logo/Application_Logo.png'),
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['room_title'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter room title";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff283C63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff283C63),
                            width: 2,
                          ),
                        ),
                        suffixIcon: Icon(Icons.title, color: Color(0xff283C63)),
                        labelText: "room_title"),
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['room_bio'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter room bio";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff283C63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff283C63),
                            width: 2,
                          ),
                        ),
                        suffixIcon:
                            Icon(Icons.info_outline, color: Color(0xff283C63)),
                        labelText: "room_bio"),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    child: Text(
                      'Add Room',
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(deviceWidth, deviceHeight * 0.070),
                      ),
                    ),
                    onPressed: () async {
                      //fetching the teacher id
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var user_id = prefs.getString('user_id') ?? 'no data';
                      var teacherToken = prefs.getString('teacher_token');
                      var teacher_id = prefs.getString('teacher_id');

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      formBody['teacher_id'] = teacher_id;

                      print(formBody);
                      BlocProvider.of<TeachercreatreroomBloc>(context)
                          .add(CreateRoom(formBody: formBody));

                      Navigator.of(context).pushNamed(
                          TeacherAddingRoomsLoadingScreen.PAGE_ROUTE);
                    },
                  ),
                  SizedBox(
                    height: deviceHeight * 0.3,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

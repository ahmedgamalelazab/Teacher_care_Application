import 'package:dio/dio.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folding_menu/folding_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/server/logic/TeacherRegisterStudent/teacherregisterstudent_bloc.dart';

import 'teacher_add_student_loading.dart';

class TeacherCreateStudentScreen extends StatefulWidget {
  static const String PAGE_ROUTE = './TeacherCreateStudentScreen';
  TeacherCreateStudentScreen({Key? key}) : super(key: key);

  @override
  _TeacherCreateStudentScreenState createState() =>
      _TeacherCreateStudentScreenState();
}

class _TeacherCreateStudentScreenState
    extends State<TeacherCreateStudentScreen> {
  List<Map<String, dynamic>> governoratesFromServer = [];
  List<Map<String, dynamic>> governoratesRelatedCity = [];
  List<Map<String, dynamic>> teacherLevelsFromTheServer = [];
  // List<Map<String, dynamic>> teacherSubjectsFromTheServer = [];
  List<String> levelsInArabic = [];
  List<String> levelsInEnglish = [];
  // List<String> subjectsInArabic = [];
  // List<String> subjectsInEnglish = [];
  List<String> governoratesInArabic = [];
  List<String> governoratesInEnglish = [];
  List<String> governorateRelatedCityInArabic = [];
  List<String> governorateRelatedCityInEnglish = [];
  String userMainPassword = "";
  //form Controllers
  final governorateController =
      DropdownEditingController<String>(); // governorate controller
  final paidForServiceController = DropdownEditingController<String>();
  final accountStateController = DropdownEditingController<String>();
  final cityController = DropdownEditingController<String>();
  final requiredLevelController = DropdownEditingController<String>();
  // final optionalOneLevelController = DropdownEditingController<String>();
  // final optionalTwoLevelController = DropdownEditingController<String>();
  // final requiredSubjectController = DropdownEditingController<String>();
  // final optionalSubjectController = DropdownEditingController<String>();

  //section of force validation
  bool payedStateServiceSubmitted = false;
  _payedServiceValidator(bool payedSubmitted) {
    if (payedSubmitted == false) {
      return null;
    } else {
      if (paidForServiceController.value == null) {
        return "enter teacher Paid state";
      } else {
        return null;
      }
    }
  }

  //account state
  bool accountStateServiceSubmitted = false;
  _accountStateServiceValidator(bool accountSubmitted) {
    if (accountSubmitted == false) {
      return null;
    } else {
      if (accountStateController.value == null) {
        return "enter teacher account state";
      } else {
        return null;
      }
    }
  }

  bool governoratesSubmitted = false;
  _governoratesStatesValidator(bool governoratesSubmitted) {
    if (governoratesSubmitted == false) {
      return null;
    } else {
      if (governorateController.value == null) {
        return "enter governorate";
      } else {
        return null;
      }
    }
  }

  bool governoratesRelatedCitySubmitted = false;
  _governorateRelatedCityValidator(bool governoratesRelatedCitySubmitted) {
    if (governoratesRelatedCitySubmitted == false) {
      return null;
    } else {
      if (cityController.value == null) {
        return "enter governorateRelatedCity";
      } else {
        return null;
      }
    }
  }

  bool teacherRequiredLevelSubmitted = false;
  _requiredLevelValidator(bool requiredLevelSubmitted) {
    if (requiredLevelSubmitted == false) {
      return null;
    } else {
      if (requiredLevelController.value == null) {
        return "enter at least one level";
      } else {
        return null;
      }
    }
  }

  // bool teacherRequiredSubjectSubmitted = false;
  // _requiredSubjectValidator(bool requiredSubjectSubmitted) {
  //   if (requiredSubjectSubmitted == false) {
  //     return null;
  //   } else {
  //     if (requiredSubjectController.value == null) {
  //       return "enter a at least one subject";
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  //end of force validation section
  //form controllers
  final _formKey = GlobalKey<FormState>();
  // bool _openMenu = false;
  // bool _openMenuSubjects = false;
  //FORM BODY will be sent in a map form not model forms
  Map<String, dynamic> formBody = {
    "user_first_name": "", //✅
    "user_last_name": "", //✅
    "user_email": "", //✅
    "user_password": "", //✅
    "user_password_confirm": "", //✅
    "user_account_state_id": 1, //✅
    "egyptian_governorate": "", //✅
    "egyptian_related_city": "", //✅
    "student_phone_number": "",
    "student_level": "", //✅
    "teacher_id": "", //✅
    "parent_first_name": "",
    "parent_last_name": ""
  };
  //the whole implementations will change when we deal with the localizations
  ///when the application starts we will fetch all governorates from the server
  _fetchAllGovernorates() async {
    try {
      final dio = new Dio();
      final response = await dio
          .get("http://192.168.0.106:4040/teacher_care/v1/governorate");
      print(response.data);
      governoratesFromServer =
          response.data['data'].cast<Map<String, dynamic>>();
      // print(governoratesFromServer.length);
      governoratesFromServer.forEach((governorateObject) {
        governoratesInArabic
            .add(governorateObject['governorate_name_ar'].toString());
        governoratesInEnglish
            .add(governorateObject['governorate_name_en'].toString());
      });

      print(governoratesInArabic.length);
      print(governoratesInEnglish.length);
    } catch (error) {
      print(error);
      //some action if the connection failed or something
    }
  }

  //fetch all the related governorates
  _fetchRelatedCity(String? governorateName) async {
    print(governorateName);
    try {
      final dio = new Dio();
      final response = await dio.get(
          "http://192.168.0.106:4040/teacher_care/v1/governorateRelatedCity/?governorate=$governorateName");
      print(response.data);
      governoratesRelatedCity = response.data.cast<Map<String, dynamic>>();
      // print(governoratesFromServer.length);
      // clear the list of the data before add more
      governorateRelatedCityInArabic.clear();
      governorateRelatedCityInEnglish.clear();
      governoratesRelatedCity.forEach((governoratesRelatedCityObject) {
        governorateRelatedCityInArabic
            .add(governoratesRelatedCityObject['city_name_ar'].toString());
        governorateRelatedCityInEnglish
            .add(governoratesRelatedCityObject['city_name_en'].toString());
      });

      print(governorateRelatedCityInArabic.length);
      print(governorateRelatedCityInEnglish.length);
    } catch (error) {
      print(error);
      //some action if the connection failed or something
    }
  }

  //!fetch all the levels from the server
  _fetchAllLevels() async {
    try {
      final dio = new Dio();
      final response = await dio.get(
          "http://192.168.0.106:4040/teacher_care/v1/students/level/fetch");
      print(response.data);
      teacherLevelsFromTheServer =
          response.data['data'].cast<Map<String, dynamic>>();
      // print(governoratesFromServer.length);
      teacherLevelsFromTheServer.forEach((teacherLevelObjects) {
        levelsInArabic.add(teacherLevelObjects['level_name_ar'].toString());
        levelsInEnglish.add(teacherLevelObjects['level_name_en'].toString());
      });

      print(levelsInArabic.length);
      print(levelsInEnglish.length);
    } catch (error) {
      print(error);
      //some action if the connection failed or something
    }
  }

  // //!fetch all the subjects from the server
  // _fetchAllSubjects() async {
  //   try {
  //     final dio = new Dio();
  //     final response = await dio
  //         .get("http://192.168.0.106:4040/teacher_care/v1/subject/fetch");
  //     print(response.data);
  //     teacherSubjectsFromTheServer =
  //         response.data['data'].cast<Map<String, dynamic>>();
  //     // print(governoratesFromServer.length);
  //     teacherSubjectsFromTheServer.forEach((teacherSubjectsObject) {
  //       subjectsInArabic
  //           .add(teacherSubjectsObject['subject_name_ar'].toString());
  //       subjectsInEnglish
  //           .add(teacherSubjectsObject['subject_name_en'].toString());
  //     });

  //     print(subjectsInArabic.length);
  //     print(subjectsInEnglish.length);
  //   } catch (error) {
  //     print(error);
  //     //some action if the connection failed or something
  //   }
  // }

  _selectRelatedCityDuringPicking() async {
    if (governorateController.value!.isNotEmpty) {
      await _fetchRelatedCity(governorateController.value);
    }
  }

  @override
  void initState() {
    governorateController.addListener(() {
      _selectRelatedCityDuringPicking();
    });
    _fetchAllGovernorates();
    _fetchAllLevels();
    // _fetchAllSubjects();
    super.initState();
  }

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
                        formBody['user_first_name'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter firstName";
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
                        suffixIcon:
                            Icon(Icons.person, color: Color(0xff283C63)),
                        labelText: "first Name"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['user_last_name'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter user last Name";
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
                        suffixIcon:
                            Icon(Icons.person, color: Color(0xff283C63)),
                        labelText: "last Name"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['parent_first_name'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter parent_first_name";
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
                        suffixIcon:
                            Icon(Icons.person, color: Color(0xff283C63)),
                        labelText: "Parent first Name"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['parent_last_name'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter parent_last_name";
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
                        suffixIcon:
                            Icon(Icons.person, color: Color(0xff283C63)),
                        labelText: "parent_last_name"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['user_email'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter userEmail";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
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
                        suffixIcon: Icon(Icons.email, color: Color(0xff283C63)),
                        labelText: "Email"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['user_password'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter userPassword";
                      }
                      userMainPassword = value;
                      print(userMainPassword);
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
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
                        suffixIcon: Icon(Icons.lock, color: Color(0xff283C63)),
                        labelText: "Password"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['user_password_confirm'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pleas enter password confirmation";
                      }
                      if (value != userMainPassword) {
                        return "Confirmed Password NotMatch";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
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
                        suffixIcon: Icon(Icons.lock, color: Color(0xff283C63)),
                        labelText: "Confirm Password"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        formBody['student_phone_number'] = value;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter teacher Phone Number";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
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
                        suffixIcon: Icon(Icons.phone, color: Color(0xff283C63)),
                        labelText: "Phone Number"),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextDropdownFormField(
                    onSaved: (dynamic str) {
                      if (accountStateController.value == null) {
                        return;
                      }
                      if (accountStateController.value!.isNotEmpty) {
                        formBody['user_account_state_id'] =
                            accountStateController.value;
                      } else {
                        return;
                      }
                    },
                    controller: accountStateController,
                    options: ['1', '2', '3', '4'],
                    decoration: InputDecoration(
                        errorText: _accountStateServiceValidator(
                            accountStateServiceSubmitted),
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
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color(0xff283C63)),
                        labelText: "Account State"),
                    dropdownHeight: 180,
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextDropdownFormField(
                    onSaved: (dynamic str) {
                      if (governorateController.value == null) {
                        return;
                      }
                      if (governorateController.value!.isNotEmpty) {
                        formBody['egyptian_governorate'] =
                            governorateController.value;
                      } else {
                        return;
                      }
                    },
                    controller: governorateController,
                    options: governoratesInArabic,
                    decoration: InputDecoration(
                        errorText:
                            _governoratesStatesValidator(governoratesSubmitted),
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
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color(0xff283C63)),
                        labelText: "governorates"),
                    dropdownHeight: 180,
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                  TextDropdownFormField(
                    onSaved: (dynamic str) {
                      if (cityController.value == null) {
                        return;
                      }
                      if (cityController.value!.isNotEmpty) {
                        formBody['egyptian_related_city'] =
                            cityController.value;
                      } else {
                        return;
                      }
                    },
                    controller: cityController,
                    options: governorateRelatedCityInArabic,
                    decoration: InputDecoration(
                        errorText: _governorateRelatedCityValidator(
                            governoratesRelatedCitySubmitted),
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
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color(0xff283C63)),
                        labelText: "city"),
                    dropdownHeight: 180,
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: deviceHeight * 0.025),
                    //✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅✳✅
                    child: TextDropdownFormField(
                      onSaved: (dynamic value) {
                        print(requiredLevelController.value);
                        if (requiredLevelController.value == null) {
                          return;
                        }
                        if (requiredLevelController.value!.isNotEmpty) {
                          formBody['student_level'] =
                              requiredLevelController.value;
                        } else {
                          return;
                        }
                      },
                      controller: requiredLevelController,
                      options: levelsInArabic,
                      decoration: InputDecoration(
                          errorText: _requiredLevelValidator(
                              teacherRequiredLevelSubmitted),
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
                          suffixIcon: Icon(Icons.arrow_drop_down,
                              color: Color(0xff283C63)),
                          labelText: "student Level"),
                      dropdownHeight: 180,
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Register',
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
                      setState(() {
                        payedStateServiceSubmitted = true;
                        accountStateServiceSubmitted = true;
                        governoratesRelatedCitySubmitted = true;
                        governoratesSubmitted = true;
                        teacherRequiredLevelSubmitted = true;
                        // teacherRequiredSubjectSubmitted = true;
                        // _openMenu = true;
                        // _openMenuSubjects = true;
                      });
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      formBody['teacher_id'] = teacher_id;
                      if (accountStateController.value == null ||
                          governorateController.value == null ||
                          cityController.value == null ||
                          requiredLevelController.value == null) {
                        return;
                      }

                      print(formBody);
                      BlocProvider.of<TeacherregisterstudentBloc>(context)
                          .add(TeacherRegisterButton(formData: formBody));

                      Navigator.of(context)
                          .pushNamed(TeacherAddStudentLoadingScreen.PAGE_ROUTE);
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
    governorateController.removeListener(() {
      _selectRelatedCityDuringPicking();
    });
    governorateController.dispose();
    paidForServiceController.dispose();
    accountStateController.dispose();
    cityController.dispose();
    requiredLevelController.dispose();
    // optionalOneLevelController.dispose();
    // optionalTwoLevelController.dispose();
    // requiredSubjectController.dispose();
    // optionalSubjectController.dispose();
    super.dispose();
  }
}

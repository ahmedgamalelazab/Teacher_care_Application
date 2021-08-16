//TODO :
//TODO make this screen after u add teachers connect with the database and fetch all the teachers and then implement the tile go to
//TODO the generic user screen profile to show the user profile screen and so on
//TODO the purpose of this screen is list all the teachers i have added already and go to their profile and in the same time add teacher from the add button

import 'package:flutter/material.dart';
import 'package:teacher_care/representation/Screens/Users/admin/admin.dart';
import 'package:teacher_care/representation/Screens/Users/admin/admin_add_teacher/admin_add_teacher.dart';

class TeacherDetailedScreenAdmin extends StatefulWidget {
  static const String ScreenRoute = '/TeacherDetailedScreenAdmin';
  TeacherDetailedScreenAdmin({Key? key}) : super(key: key);

  @override
  _TeacherDetailedScreenAdminState createState() =>
      _TeacherDetailedScreenAdminState();
}

class _TeacherDetailedScreenAdminState
    extends State<TeacherDetailedScreenAdmin> {
  //dummy data will hold all the teachers that i already created
  //the search filter will handle the situation
  List<String> dummyData = [
    'ahmed gamal',
    'Jimmy Nitron',
    'Moly Holy',
    'ZeedoCooker',
    'MonaZaa',
    'Ahmed Moo',
    'Ahmed Mero',
    'ahmed bero',
    'Kareem Kero',
    'dummyTeacherThree',
    'dummyTeacherThree',
    'dummyTeacherThree',
    'dummyTeacherThree',
    'dummyTeacherThree',
    'dummyTeacherThree',
    'blablabla',
  ];

  List<String> searchList = [];

  final teacherSearchController = TextEditingController();

  @override
  void initState() {
    teacherSearchController.addListener(() {
      _teachersFilter();
    });
    super.initState();
  }

  _teachersFilter() {
    List<String> dummyFilter = [];
    dummyFilter.addAll(dummyData);
    if (teacherSearchController.text.isNotEmpty) {
      dummyFilter.retainWhere((teacher) {
        String searchTerm = teacherSearchController.text.toLowerCase();
        String teacherName = teacher.toLowerCase();
        return teacherName.contains(searchTerm);
      });
    }
    setState(() {
      searchList = dummyFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('search List length = ' + searchList.length.toString());
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final clearDeviceHeight = deviceHeight - MediaQuery.of(context).padding.top;
    print(clearDeviceHeight);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //go to add teacher screen
            Navigator.of(context)
                .pushNamed(AdminCreateTeacherFormScreen.ScreenRoute)
                .then(
                  (_) => Navigator.of(context).pop(),
                );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff283C63),
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: clearDeviceHeight * 0.1,
                width: deviceWidth,
                color: Color(0xff283C63),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: deviceWidth * 0.85,
                    //TODO implements the search future using the controller
                    child: Container(
                      // width: deviceWidth * 0.8,
                      child: TextField(
                        controller: teacherSearchController,
                        decoration: InputDecoration(
                          hintText: 'search for teacher',
                          contentPadding: EdgeInsets.all(0),
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(deviceWidth * 0.25)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(deviceWidth * 0.25)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(deviceWidth * 0.25)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                // height: clearDeviceHeight * 0.9,
                // color: Color(0xfff2f2f2),
                child: searchList.length == 0
                    ? ListView.builder(
                        itemCount: dummyData.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(dummyData[index]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchList.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(searchList[index]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    teacherSearchController.removeListener(() {
      _teachersFilter();
    });
    teacherSearchController.dispose();
    super.dispose();
  }
}

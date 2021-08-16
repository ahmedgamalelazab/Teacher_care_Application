import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_care/representation/Screens/Users/teacher/teacherCreateStudent.dart';
import 'package:teacher_care/server/data_providers/teacher_create_room.dart';
import 'package:teacher_care/server/logic/TeacherCreateRoom/teachercreatreroom_bloc.dart';
import 'package:teacher_care/server/models/roomsFromServer.dart';

import 'teacher_add_room.dart';

class TeacherRoomsScreen extends StatefulWidget {
  static const String PageRoute = './TeacherRoomsScreen';
  TeacherRoomsScreen({Key? key}) : super(key: key);

  @override
  _TeacherRoomsScreenState createState() => _TeacherRoomsScreenState();
}

class _TeacherRoomsScreenState extends State<TeacherRoomsScreen> {
  //!this list will play the role of data getter from the server
  List<String> dummyData = [];
  List<dynamic> serverData = [];
  _screenInitState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id') ?? 'no data';
    var teacherToken = prefs.getString('teacher_token');
    BlocProvider.of<TeachercreatreroomBloc>(context)
        .add(GetTeacherRooms(teacher_token: teacherToken ?? "no token"));
  }

  _fetchRoomsFromServer() async {
    await Future.delayed(Duration(seconds: 3));
    TeacherRoomsSingleton rooms = new TeacherRoomsSingleton();
    serverData = rooms.getRooms();
    print(serverData);
    serverData.forEach((obj) {
      setState(() {
        dummyData.add(obj['room_name']);
      });
    });
  }

  //!this list will appear on the screen when the search complete
  List<String> searchList = [];

  final teacherRoomsController = TextEditingController();

  @override
  void initState() {
    teacherRoomsController.addListener(() {
      _teachersFilter();
    });
    _screenInitState();
    _fetchRoomsFromServer();
    super.initState();
  }

  _teachersFilter() {
    List<String> dummyFilter = [];
    dummyFilter.addAll(dummyData);
    if (teacherRoomsController.text.isNotEmpty) {
      dummyFilter.retainWhere((student) {
        String searchTerm = teacherRoomsController.text.toLowerCase();
        String studentName = student.toLowerCase();
        return studentName.contains(searchTerm);
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
            Navigator.of(context).pushNamed(TeacherAddRoomScreen.PAGE_ROUTE);
            //! add room from here
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
                        controller: teacherRoomsController,
                        decoration: InputDecoration(
                          hintText: 'search for specific room',
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
                          subtitle: Text(serverData[index]['room_bio']),
                          trailing: serverData[index]
                                      ['video_conference_state'] ==
                                  false
                              ? Icon(Icons.switch_video)
                              : Icon(Icons.switch_video, color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchList.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(searchList[index]),
                          subtitle: Text(serverData[index]['room_bio']),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

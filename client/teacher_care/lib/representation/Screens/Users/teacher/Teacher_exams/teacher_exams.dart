import 'package:flutter/material.dart';

class TeacherExams extends StatefulWidget {
  static const String Page_route = './TeacherExams';
  const TeacherExams({Key? key}) : super(key: key);

  @override
  _TeacherExamsState createState() => _TeacherExamsState();
}

class _TeacherExamsState extends State<TeacherExams> {
  //!this list will play the role of data getter from the server // later on this will connect to the server
  List<String> dummyData = [
    'Dummy Exam 1',
    'Dummy Exam 2',
    'Dummy Exam 3',
    'Dummy Exam 4',
    'Dummy Exam 5',
    'Dummy Exam 6',
    'Dummy Exam 7',
    'Dummy Exam 8',
    'Dummy Exam 9',
    'Dummy Exam 10',
    'Dummy Exam 11',
    'Dummy Exam 12',
    'Dummy Exam 13',
    'Dummy Exam 14',
    'Dummy Exam 15',
    'Dummy Exam 16',
    'Dummy Exam 17',
    'Dummy Exam 18',
  ];

  //!this list will appear on the screen when the search complete
  List<String> searchList = [];

  final teacherRoomsController = TextEditingController();

  @override
  void initState() {
    teacherRoomsController.addListener(() {
      _teachersFilter();
    });
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Navigator.of(context)
        //     //     .pushNamed(TeacherCreateStudentScreen.PAGE_ROUTE)
        //     //     .then(
        //     //       (_) => Navigator.of(context).pop(),
        //     //     );
        //     // print('student will be added from this form');
        //     // Navigator.of(context).pushNamed(TeacherAddRoomScreen.PAGE_ROUTE);
        //     //! add room from here
        //   },
        //   child: Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Color(0xff283C63),
        // ),
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
                          hintText: 'search for student',
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
}

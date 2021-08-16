// in this module we will make the teacher able to fetch his data normally using his token

//importing dio to make the connections

import 'package:dio/dio.dart';

abstract class TeacherApi {
  Future<Map<String, dynamic>> fetchTeacherData(
      {required String teacherToken}); // pure virtual function
}

//is a relationship
class TeacherDataProvider extends TeacherApi {
  @override
  Future<Map<String, dynamic>> fetchTeacherData(
      {required String teacherToken}) async {
    try {
      final dio = new Dio();
      //this screen will fetch the user token from the internal storage
      dio.options.headers['x-auth-token'] = teacherToken;
      final response = await dio.get(
          'http://192.168.0.106:4040/teacher_care/v1/systemTeacherData/teacher');
      //if all are ok
      return response.data;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data":
            "error during fetching the user teacher from the server in the data provider section !"
      };
    }
  }
}

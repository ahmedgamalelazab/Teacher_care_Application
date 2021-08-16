//api interface

import 'package:dio/dio.dart';

abstract class Teacher_Register_Api {
  Future<Map<String, dynamic>> postStudnetToSystem(
      Map<String, dynamic> formBody);
}

class Teacher_Register_To_System extends Teacher_Register_Api {
  @override
  Future<Map<String, dynamic>> postStudnetToSystem(
      Map<String, dynamic> formBody) async {
    try {
      Dio dio = Dio();
      dio.options.contentType = 'application/json';
      final response = await dio.post(
          'http://192.168.0.106:4040/teacher_care/v1/teacher/student/register',
          data: formBody);
      //if all are ok
      return response.data;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data":
            "error during registering a student in the dataBase in the provider section"
      };
    }
  }
}

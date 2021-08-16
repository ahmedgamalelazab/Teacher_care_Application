// this provider suppose to connect with the admin teacher register form and it will be not generic
import 'package:dio/dio.dart';

abstract class AdminTeacherAuthApi {
  Future<Map<String, dynamic>> adminTeacherAuth(
      {required Map<String, dynamic> body});
}

class AdminTeacherRegister extends AdminTeacherAuthApi {
  @override
  Future<Map<String, dynamic>> adminTeacherAuth(
      {required Map<String, dynamic> body}) async {
    try {
      final dio = new Dio();
      // the form
      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.post(
          'http://192.168.0.106:4040/teacher_care/v1/admin/teacher/register',
          data: body);
      print(response.data);
      return response.data;
    } catch (error) {
      print(error);
      return {
        "success:": false,
        "data": "error occurred in the admin teacher provider "
      };
    }
  }
}

//here is the auth api to deal with the server side of the teacher care application

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teacher_care/utils/js/js_console_log.dart';
import 'package:dio/dio.dart';

abstract class AuthApi {
  Future<Map<String, dynamic>> user_auth(Map<String, dynamic> body);
  //update user Data after Login
  Future<Map<String, dynamic>> updateUserDataAfterLogin(String userId);
  //user logout service
  Future<void> userLogOutService({required String userId});
}

class UserAuth extends AuthApi {
  @override
  Future<Map<String, dynamic>> user_auth(Map<String, dynamic> body) async {
    // we get the uri first
    final todoUri =
        Uri.parse("http://192.168.0.106:4040/teacher_care/v1/user/login");
    //second step is trying to
    try {
      final serverResponse = await http.post(
        todoUri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "user_email": body["user_email"],
            "user_password": body["user_password"],
          },
        ),
      );
      final responseResult =
          json.decode(serverResponse.body) as Map<String, dynamic>;
      return responseResult;
    } catch (error) {
      Console.log(error);
      return {"success": false, "data": "error located in the api model"};
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserDataAfterLogin(
      //we will send the user token from this route and it will connect to the backend and give it the token and the backend will response the user update from this token
      String userToken) async {
    final todoUri = Uri.parse(
        "http://192.168.0.106:4040/teacher_care/v1/user_utils/user/updateProfileAfterLogin/");
    //second step is trying to
    try {
      final serverResponse = await http.get(
        todoUri,
        headers: {"x-auth-token": userToken},
      );
      final responseResult =
          json.decode(serverResponse.body) as Map<String, dynamic>;
      return responseResult;
    } catch (error) {
      Console.log(error);
      return {
        "success": false,
        "data": "error located in the updateUser state after Login api"
      };
    }
  }

  @override
  Future<void> userLogOutService({required String userId}) async {
    final dio = new Dio();
    final response = await dio.get(
        'http://192.168.0.106:4040/teacher_care/v1/teacher/control/logOut/${userId}');
  }
}


//user logout 


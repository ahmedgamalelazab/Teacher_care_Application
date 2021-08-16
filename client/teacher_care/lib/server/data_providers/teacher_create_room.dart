//api interface

import 'package:dio/dio.dart';

import '../models/roomsFromServer.dart';

abstract class TeacherCreateRoomApi {
  Future<Map<String, dynamic>> postSessionRoom(Map<String, dynamic> formBody);
  Future<dynamic> getTeacherRooms({required String teacher_token});
}

class TeacherCreateRoom extends TeacherCreateRoomApi {
  @override
  Future<Map<String, dynamic>> postSessionRoom(
      Map<String, dynamic> formBody) async {
    try {
      Dio dio = Dio();
      dio.options.contentType = 'application/json';
      final response = await dio.post(
          'http://192.168.0.106:4040/teacher_care/v1/room/create',
          data: formBody);
      //if all are ok
      return response.data;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data":
            "error during adding room in the dataBase in the provider section"
      };
    }
  }

  @override
  Future<dynamic> getTeacherRooms({required String teacher_token}) async {
    try {
      final dio = new Dio();
      dio.options.headers['x-auth-token'] = teacher_token;
      final response = await dio.get(
          'http://192.168.0.106:4040/teacher_care/v1/room/getTeacherRooms');
      print(response.data);
      TeacherRoomsSingleton rooms = new TeacherRoomsSingleton();
      rooms.setRooms(serverData: response.data['data']);
      // print(rooms.getRooms());
      return response.data;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "error during fetching teacher_rooms",
      };
    }
  }
}

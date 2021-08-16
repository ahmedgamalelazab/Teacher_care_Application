import '../data_providers/teacher_create_room.dart';

class TeacherCreateRoomRepository {
  TeacherCreateRoomApi teacherCreateRoomApi;

  TeacherCreateRoomRepository({required this.teacherCreateRoomApi});

  Future<Map<String, dynamic>> postStudent(
      Map<String, dynamic> formBody) async {
    try {
      final dataRaw = await teacherCreateRoomApi.postSessionRoom(formBody);
      //if all are ok
      return dataRaw;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "error during adding a room in the repository section !"
      };
    }
  }

  Future<dynamic> getTeacherRooms({required String teacher_token}) async {
    try {
      final data = await teacherCreateRoomApi.getTeacherRooms(
          teacher_token: teacher_token);
      //if every thing is ok
      return data;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "error in the data repository while fetching teachers rooms ",
      };
    }
  }
}

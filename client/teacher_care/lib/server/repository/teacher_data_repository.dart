// teacher data repository

import 'package:teacher_care/server/data_providers/teacher_data.dart';

class TeacherDataRepository {
  final TeacherApi teacherApi;

  TeacherDataRepository({required this.teacherApi});

  //section of functions

  Future<Map<String, dynamic>> teacherDataRaw(
      {required String teacherToken}) async {
    try {
      final dataRaw =
          await teacherApi.fetchTeacherData(teacherToken: teacherToken);
      return dataRaw;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data":
            "error during fetching teacher data in the repository section !",
      };
    }
  }
}

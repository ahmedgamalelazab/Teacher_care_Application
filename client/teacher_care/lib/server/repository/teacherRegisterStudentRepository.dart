import '../data_providers/teacher_student_register_to_system.dart';

class TeacherRegisterStudentRepository {
  Teacher_Register_Api teacherRegisterApi;

  TeacherRegisterStudentRepository({required this.teacherRegisterApi});

  Future<Map<String, dynamic>> postStudent(
      Map<String, dynamic> formBody) async {
    try {
      final dataRaw = await teacherRegisterApi.postStudnetToSystem(formBody);
      //if all are ok
      return dataRaw;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "error during registering a student in the repository section !"
      };
    }
  }
}

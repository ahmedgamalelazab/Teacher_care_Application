import 'package:teacher_care/server/data_providers/admin_teacher_register_to_system.dart';

class AdminTeacherRegisterRepository {
  final AdminTeacherAuthApi adminTeacherRegisterApi;

  AdminTeacherRegisterRepository({required this.adminTeacherRegisterApi});

  Future<Map<String, dynamic>> adminTeacherRegisterResponseDataRaw(
      {required Map<String, dynamic> body}) async {
    try {
      final dataRaw =
          await adminTeacherRegisterApi.adminTeacherAuth(body: body);
      //if all are ok we will return the data
      return dataRaw;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "admin teacher register repository error !"
      };
    }
  }
}

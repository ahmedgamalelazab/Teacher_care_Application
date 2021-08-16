import '../authDataBase.dart';

class AuthInternalDataBaseRepository {
  final AuthInternalStorageDataBaseHelper authInternalDataBaseHelper;

  AuthInternalDataBaseRepository({required this.authInternalDataBaseHelper});

  // Future<void> openDataBase() async {
  //   try {
  //     await authInternalDataBaseHelper.openDataBase();
  //     //if every thing run well we will be able to connect to the rest of all api
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  //insert data Repository

  Future<Map<String, dynamic>> insertDataInternally(
      {required Map<String, dynamic> data}) async {
    try {
      final internalResponse =
          await authInternalDataBaseHelper.insertInDB(data);
      //if all run ok
      return internalResponse;
    } catch (error) {
      print(error);
      return {"success": false, "data": "error during the insertion process"};
    }
  }

  Future<dynamic> fetchUserDataIfExistsInMyDataBase(
      {required String userId}) async {
    try {
      final internalResponse =
          await authInternalDataBaseHelper.fetchLocallyUserId(userId);
      //if all run ok lets return data
      return internalResponse;
    } catch (error) {
      print(error);
      return 'error during fetching data internally from the repository';
    }
  }
}

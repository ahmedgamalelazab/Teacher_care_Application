import '../../database/authDataBase.dart';
import '../data_providers/auth_api.dart';
import '../../utils/js/js_console_log.dart';

//TODO IMPLEMENTS INTERNAL STORAGE INSERTION TO ACCOMPLISH TEACHER SCREEN GOAL

class AuthRepository {
  final AuthApi userApi;
  final AuthInternalStorageDataBaseHelper internalStorage;
  //main data will be stored here for late usage
  late Map<String, dynamic> dataRaw;

  AuthRepository({required this.userApi, required this.internalStorage});

  Future<Map<String, dynamic>> user_auth_data_raw(
      Map<String, dynamic> formBody) async {
    bool userInsertedDataOrNotInternally = false;
    try {
      dataRaw = await userApi.user_auth(formBody);
      //im injecting live instance of the internalDataBsae helper and it will connect automatically so i won't connect again
      final internalResponse =
          await internalStorage.fetchLocallyUserId(dataRaw['data']['user_id']);

      if (internalResponse.length != 0) {
        if (internalResponse[0]['userId'] == dataRaw['data']['user_id']) {
          userInsertedDataOrNotInternally = true;
          print(
              'insertion internally should not be done because the user is already stored already');
        }
      }
      //if user id inserted internally this function will be not touched and we will fetch this data later using the id
      if (userInsertedDataOrNotInternally == false) {
        await internalStorage.insertInDB(
          {
            'user_id': dataRaw['data']['user_id'],
            'user_token': dataRaw['data']['teacher_token'],
            'user_role': dataRaw['data']['user_role']
          },
        );
        print('inserted user data internally successfully!');
      }

      return dataRaw;
    } catch (error) {
      Console.log(error);
      return {"success": false, "data": "the error located in the repository"};
    }
  }

  Future<Map<String, dynamic>> updateUserDataAfterLoginDataRaw(
      String token) async {
    try {
      final dataRaw = await userApi.updateUserDataAfterLogin(token);
      return dataRaw;
    } catch (error) {
      Console.log(error);
      return {"success": false, "data": "the error located in the repository"};
    }
  }

  Future<void> logUserOut({required String user_id}) async {
    final response = await userApi.userLogOutService(userId: user_id);
  }
}

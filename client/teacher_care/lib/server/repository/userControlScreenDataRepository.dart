import '../data_providers/userUtilsApi.dart';

class UserUtilsControlScreenRepository {
  final UserUtilsApi userUtilsApi;

  UserUtilsControlScreenRepository({required this.userUtilsApi});

  Future<Map<String, dynamic>> fetchControlScreenDataRaw(
      {required String userToken}) async {
    try {
      final response =
          await userUtilsApi.fetchControlScreenData(userToken: userToken);
      // if all are ok with no errors
      return response;
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data":
            "error occurred in the user Control Screen data fetcher repository"
      };
    }
  }
}

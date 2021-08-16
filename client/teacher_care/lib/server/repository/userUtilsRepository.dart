//this repository will handle the job with the upload images service

import 'package:teacher_care/representation/componets/constant/userUploadImagesUtils.dart';
import 'package:teacher_care/server/data_providers/userUtilsApi.dart';

class UserUploadImagesUtilsRepository {
  // this class has a userUtilsApi
  final UserUtilsApi userUtilsApi;
  dynamic dataRaw;
  UserUploadImagesUtilsRepository({required this.userUtilsApi});

  //fetch data raw from the server

  Future<Map<String, dynamic>> uploadServiceDataRaw(
      Map<String, dynamic> data, UserUploadEnumsUtils choice) async {
    //cool
    try {
      print('checking data here');
      print(data);
      dataRaw = await userUtilsApi.uploadUserImages(data, choice);
      print(dataRaw);
      // wishes the dataRaw comes in format of Map<String , dynamic>
      return dataRaw;
    } catch (error) {
      print(error);
      return {"success": false, "data": " error occur in the repository file!"};
    }

    //worst case of no data
  }
}

//here this util should be generic and works for all users profile

import 'package:teacher_care/representation/componets/constant/userUploadImagesUtils.dart';

import 'package:dio/dio.dart';

// import 'package:http_parser/http_parser.dart';

// admin , moderatos and teachers considered as they are semi admins
// i will design only one provider and only one route for all of them and the response will have to split them over
// the system will detect if the user is admin or moderator or just a teacher to give him the get back data utils

abstract class UserUtilsApi {
  Future<Map<String, dynamic>> uploadUserImages(
      Map<String, dynamic> data, UserUploadEnumsUtils uploadType);
  Future<Map<String, dynamic>> fetchControlScreenData(
      {required String userToken});
}

class UserUtilsImplementation extends UserUtilsApi {
  @override
  Future<Map<String, dynamic>> uploadUserImages(
      Map<String, dynamic> data, UserUploadEnumsUtils uploadType) async {
    print(
      'data loaded in the final dataProvider : ' +
          data['user_profile_image_file'],
    );
    print(data);
    //!try this
    final dio = new Dio();
    switch (uploadType) {
      case UserUploadEnumsUtils.UploadProfileImage:
        //!upload profile image choice
        try {
          dio.options.headers['content-Type'] = 'multipart/form-data';
          dio.options.headers['x-auth-token'] = data['user_token'];
          // do some code here
          String fileName =
              data['user_profile_image_file'].toString().split('/').last;
          print(fileName);
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              data['user_profile_image_file'],
              filename: fileName,
            ),
          });
          final response = await dio.post(
              'http://192.168.0.106:4040/teacher_care/v1/user_utils/upload/profileImages',
              data: formData);
          print(response);
          print(response.data);
          return response.data;
        } catch (error) {
          print(error);
          return {
            "success:": false,
            "data": "error occurred in the dataProviderSection"
          };
        }
      case UserUploadEnumsUtils.UploadCoverImage:
        try {
          //! in case of upload cover images
          dio.options.headers['content-Type'] = 'multipart/form-data';
          dio.options.headers['x-auth-token'] = data['user_token'];
          //do some code here
          String fileName =
              data['user_cover_image_file'].toString().split('/').last;
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              data['user_cover_image_file'],
              filename: fileName,
            ),
          });
          final response = await dio.post(
              'http://192.168.0.106:4040/teacher_care/v1/user_utils/upload/coverImages',
              data: formData);
          print(response);
          print(response.data);
          return response.data;
        } catch (error) {
          print(error);
          return {
            "success:": false,
            "data": "error occurred in the dataProvider"
          };
        }
      default:
        return {"success": false, "data": "error occurred in the dataProvider"};
    }
  }

  @override
  Future<Map<String, dynamic>> fetchControlScreenData(
      {required String userToken}) async {
    try {
      final dio = Dio();
      dio.options.headers['x-auth-token'] = userToken;
      final response = await dio.get(
          'http://192.168.0.106:4040/teacher_care/v1/user_utils/user/controlScreen/data/fetch/');
      return response.data;
    } catch (error) {
      print(error);
      return {
        'success': false,
        "data": "error occurred in the provider section"
      };
    }
  }
}

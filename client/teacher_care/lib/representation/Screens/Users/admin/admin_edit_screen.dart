import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

// this screen will completely isolated from all the others screens
// updating the user bio won't need to change a lot of screens so here we will do all the states internally

class PatchUserBioScreen extends StatefulWidget {
  static const String SCREEN_ROUTE = '/PatchUserBioScreen';
  PatchUserBioScreen({Key? key}) : super(key: key);

  @override
  _PatchUserBioScreenState createState() => _PatchUserBioScreenState();
}

class _PatchUserBioScreenState extends State<PatchUserBioScreen> {
  final bioTextFieldEditing = TextEditingController();

  bool isInitial = false;

  //TODO implement data receive from the user Profile screen to show it as default one
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final userProfileArguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (!isInitial) {
      bioTextFieldEditing.text = userProfileArguments['user_bio'];
      isInitial = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('edit bio'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * 0.050,
                right: deviceWidth * 0.050,
                bottom: deviceWidth * 0.050,
              ),
              //here where i will take the bio from the user
              child: Container(
                child: TextField(
                  maxLength: TextField.noMaxLength,
                  maxLines: 5,
                  controller: bioTextFieldEditing,
                ),
              ),
            ),
            //every single source of data need an action to register this data somewhere
            Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * 0.050,
                right: deviceWidth * 0.050,
                bottom: deviceWidth * 0.050,
              ),
              //here where i will take the bio from the user
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(deviceWidth, deviceWidth * 0.085),
                  ),
                ),
                onPressed: () async {
                  // we will talk to the server from here
                  try {
                    final dio = Dio();
                    dio.options.headers['x-auth-token'] =
                        userProfileArguments['token'];
                    dio.options.headers['content-Type'] = 'application/json';
                    final response = await dio.patch(
                        "http://192.168.0.106:4040/teacher_care/v1/user_utils/user/patchUserBio/",
                        data: {"user_bio": bioTextFieldEditing.value.text});
                    print(response.data);
                    bioTextFieldEditing.text =
                        response.data['data']['admin_bio'];
                  } catch (error) {
                    print(error);
                  }
                },
                child: Text('submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bioTextFieldEditing.dispose();
    super.dispose();
  }
}

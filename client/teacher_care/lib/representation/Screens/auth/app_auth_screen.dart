import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_care/representation/Screens/Users/loading_screen/auth_loading_screen.dart';
import 'package:teacher_care/server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';
import 'package:teacher_care/utils/js/js_console_log.dart';

import '../../componets/constant/application_enums.dart';
import '../../componets/widgets/auth_componets.dart';
import 'package:animate_do/animate_do.dart';

//TODO fix all the screen sizes for the tablet and tv size !

class UserAuthScreen extends StatelessWidget {
  static const String SCREEN_ROUTE = '/UserAuthScreen';
  UserAuthScreen({Key? key}) : super(key: key);

  final form_key = GlobalKey<FormState>();

  final Map<String, dynamic> formBody = {"user_email": "", "user_password": ""};

  @override
  Widget build(BuildContext context) {
    final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
    Console.log(device_width);
    if (device_width <= 320.00) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.8,
          logoHeight: 0.08,
          auth_field_control_top_padding: 0.015,
          auth_field_control_container_height: 0.057515625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 320 && device_width <= 480) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.65,
          logoHeight: 0.076,
          auth_field_control_top_padding: 0.020,
          auth_field_control_container_height: 0.05915625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 480 && device_width <= 540) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 540 && device_width <= 600) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.80,
          logoHeight: 0.23,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.1515625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 600 && device_width <= 640) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.18,
          auth_field_control_top_padding: 0.020,
          auth_field_control_container_height: 0.1015625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 640 && device_width <= 720) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 720 && device_width <= 760) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.025,
          auth_field_control_container_height: 0.12513115625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 720 && device_width <= 768) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.18,
          auth_field_control_top_padding: 0.001,
          auth_field_control_container_height: 0.07013115625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 768 && device_width <= 800) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 800 && device_width <= 820) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.025,
          auth_field_control_container_height: 0.10915625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 820 && device_width <= 896) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.03,
          auth_field_control_container_height: 0.130215625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 800 && device_width <= 1024) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.000010,
          auth_field_control_container_height: 0.09215625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1024 && device_width <= 1125) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1125 && device_width <= 1366) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.25,
          auth_field_control_top_padding: 0.001121,
          auth_field_control_container_height: 0.080015625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1366 && device_width <= 1680) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1366 && device_width <= 1921) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1366 && device_width <= 1921) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 1921 && device_width <= 4096) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
      return BounceInRight(
        child: Auth_Scaffold_Responsive(
          formBody: formBody,
          formKey: form_key,
          device_height: device_height,
          device_width: device_width,
          logoWidth: 0.70,
          logoHeight: 0.095,
          auth_field_control_top_padding: 0.035,
          auth_field_control_container_height: 0.0715625,
          auth_field_control_container_width: 0.8,
        ),
      );
    } else if (device_width > 4096 && device_width <= 5120) {
      //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
      //return something
    }
    //✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    return BounceInRight(
      child: Auth_Scaffold_Responsive(
        formBody: formBody,
        formKey: form_key,
        device_height: device_height,
        device_width: device_width,
        logoWidth: 0.65,
        logoHeight: 0.076,
        auth_field_control_top_padding: 0.020,
        auth_field_control_container_height: 0.05915625,
        auth_field_control_container_width: 0.8,
      ),
    );
  }
}

class Auth_Scaffold_Responsive extends StatelessWidget {
  const Auth_Scaffold_Responsive({
    Key? key,
    required this.device_height,
    required this.device_width,
    required this.logoWidth,
    required this.logoHeight,
    required this.auth_field_control_top_padding,
    required this.auth_field_control_container_height,
    required this.auth_field_control_container_width,
    required this.formKey,
    required this.formBody,
  }) : super(key: key);

  final double device_height;
  final double device_width;
  final double logoWidth;
  final double logoHeight;
  final double auth_field_control_top_padding;
  final double auth_field_control_container_height;
  final double auth_field_control_container_width;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formBody;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserAuthBlocBloc, UserAuthBlocState>(
      builder: (context, state) => Scaffold(
        body: Container(
          height: device_height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            // controller: controller,
            child: Form(
              key: formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo size will be registered here
                  Container(
                    width: device_width * logoWidth, //0.40,
                    height: device_height * logoHeight, //0.075,
                    child: Image.asset(
                      'assets/images/logo/Application_Logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  //user EmailAddress
                  AuthFields(
                    formBody: formBody,
                    device_height: device_height,
                    device_width: device_width,
                    fieldType: AuthFieldType.EMAIL,
                    edgeInsetsPaddingFromTop:
                        auth_field_control_top_padding, //0.015,
                    height_of_container:
                        auth_field_control_container_height, //0.007515625,
                    width_of_container:
                        auth_field_control_container_width, //0.8,
                  ),
                  //user password
                  AuthFields(
                    formBody: formBody,
                    device_height: device_height,
                    device_width: device_width,
                    fieldType: AuthFieldType.PASSWORD,
                    edgeInsetsPaddingFromTop:
                        auth_field_control_top_padding, //0.015,
                    height_of_container:
                        auth_field_control_container_height, //0.007515625,
                    width_of_container:
                        auth_field_control_container_width, //0.8,
                  ),
                  //button to let me log in
                  Container(
                    margin: EdgeInsets.only(
                      top: device_height * auth_field_control_top_padding,
                    ), //0.015),
                    width: device_width *
                        auth_field_control_container_width, //0.8,
                    height: device_height *
                        auth_field_control_container_height, //0.007515625,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff283C63)),
                      ),
                      onPressed: () {
                        formKey.currentState!.save();
                        final finalBody = formBody;
                        BlocProvider.of<UserAuthBlocBloc>(context,
                                listen: false)
                            .add(UserLogin(body: finalBody));
                      },
                      child: Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      listener: (context, state) {
        Console.log(state);
        if (state is UserAuthLoading) {
          Navigator.of(context)
              .pushReplacementNamed(Auth_Loading_Screen.SCREEN_ROUTE);
        }
      },
    );
  }
}

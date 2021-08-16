import 'package:flutter/material.dart';
import 'package:teacher_care/utils/js/js_console_log.dart';

import '../constant/application_enums.dart';

class AuthFields extends StatelessWidget {
  const AuthFields({
    Key? key,
    required this.device_height,
    required this.device_width,
    required this.fieldType,
    required this.edgeInsetsPaddingFromTop,
    required this.width_of_container,
    required this.height_of_container,
    required this.formBody,
  }) : super(key: key);

  final double device_height;
  final double device_width;
  final AuthFieldType fieldType;
  final double edgeInsetsPaddingFromTop;
  final double width_of_container;
  final double height_of_container;
  final Map<String, dynamic> formBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: device_height * edgeInsetsPaddingFromTop), //0.025),
      width: device_width * width_of_container, //0.8,
      height: device_height * height_of_container, //0.0515625,
      child: TextFormField(
        onSaved: (data) => _take_action_depends_on_field_type(data, fieldType),
        keyboardType: TextInputType.emailAddress,
        obscureText: _pick_a_obsecured_or_not(fieldType),
        decoration: InputDecoration(
          labelText: _pick_A_type(fieldType),
          prefixIcon: _pick_A_Icon(fieldType),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1, //#️⃣
              color: Color(0xff979797), //#️⃣
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Color(0xff979797),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Color(0xff020202),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  String _pick_A_type(AuthFieldType fieldType) {
    switch (fieldType) {
      case AuthFieldType.EMAIL:
        return 'Email';
      case AuthFieldType.PASSWORD:
        return 'Password';
      default:
        return 'UnkownType';
    }
  }

  Icon _pick_A_Icon(AuthFieldType fieldType) {
    switch (fieldType) {
      case AuthFieldType.EMAIL:
        return Icon(Icons.person, color: Color(0xff283C63));
      case AuthFieldType.PASSWORD:
        return Icon(Icons.lock, color: Color(0xff283C63));
      default:
        return Icon(Icons.lock, color: Color(0xff283C63));
    }
  }

  bool _pick_a_obsecured_or_not(AuthFieldType fieldType) {
    switch (fieldType) {
      case AuthFieldType.EMAIL:
        return false;
      case AuthFieldType.PASSWORD:
        return true;
      default:
        return false;
    }
  }

  void _take_action_depends_on_field_type(
      String? data, AuthFieldType fieldType) {
    switch (fieldType) {
      case AuthFieldType.EMAIL:
        formBody['user_email'] = data;
        break;
      case AuthFieldType.PASSWORD:
        formBody['user_password'] = data;
        break;
      default:
    }
    // Console.log(formBody);
  }
}

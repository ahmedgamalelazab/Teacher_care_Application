import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_care/server/logic/user_auth_bloc/user_auth_bloc_bloc.dart';
import 'package:teacher_care/utils/js/js_console_log.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// i will connect this screen with the bloc to obtain the latest state from the bloc and after that i will
//create the bloc and continue the profile work up to finish it all

class Parent_Screen extends StatefulWidget {
  static const String SCREEN_ROUTE = '/Parent_Screen';
  const Parent_Screen({Key? key}) : super(key: key);

  @override
  _Parent_ScreenState createState() => _Parent_ScreenState();
}

class _Parent_ScreenState extends State<Parent_Screen> {
  dynamic userState;
  int begin = 0;
  //hashing the screen into numbers then call a splitter function
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    //we make something here like init state but in the same time it's not
    // not once the screen open we will snap the state in the bloc and store it in a variable to extract this later
    if (begin == 0) {
      userState =
          BlocProvider.of<UserAuthBlocBloc>(context, listen: false).state;
      begin++;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final device_height = MediaQuery.of(context).size.height;
    final device_width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.indigoAccent,
        buttonBackgroundColor: Color(0xff283C63),
        items: <Widget>[
          Icon(Icons.person, size: 50, color: Colors.white),
          Icon(Icons.list, size: 50, color: Colors.white),
          Icon(Icons.settings, size: 50, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: _display_proper_screen(currentIndex, device_height, device_width),
    );
  }
}

_display_proper_screen(
    int currentIndex, double deviceHeight, double deviceWidth) {
  //this is the splitter so lets test it
  switch (currentIndex) {
    case 0:
      return Center(
        child: Text('Parent profile'),
      );
    case 1:
      return Center(
        child: Text('Parent Messages'),
      );
    case 2:
      return Center(
        child: Text('Parent settings'),
      );
    default:
  }
}

part of 'teacherdata_bloc.dart';

@immutable
abstract class TeacherdataEvent {}

class FetchTeacherData extends TeacherdataEvent {
  // this is an action
  final String userToken;

  FetchTeacherData({required this.userToken});
}

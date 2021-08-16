part of 'teachercreatreroom_bloc.dart';

@immutable
abstract class TeachercreatreroomEvent {}

class CreateRoom extends TeachercreatreroomEvent {
  final Map<String, dynamic> formBody;

  CreateRoom({required this.formBody});
}

class GetTeacherRooms extends TeachercreatreroomEvent {
  final String teacher_token;

  GetTeacherRooms({required this.teacher_token});
}

part of 'teachercreatreroom_bloc.dart';

@immutable
abstract class TeachercreatreroomState {}

class TeachercreatreroomInitial extends TeachercreatreroomState {}

//loading state will be thrown when the use clock the button
class LoadingCreateRoomEvent extends TeachercreatreroomState {}

class TeacherCreateRoomCreated extends TeachercreatreroomState {
  final Map<String, dynamic> data;

  TeacherCreateRoomCreated({required this.data});
}

class LoadImageAfterLoadingComplete extends TeachercreatreroomState {}

class TeacherCreateRoomDataLoadError extends TeachercreatreroomState {
  final String error;

  TeacherCreateRoomDataLoadError({required this.error});
}

class LoadingTeacherRoomsFromTheServer extends TeachercreatreroomState {}

class RoomsDataLoadedFromTheServer extends TeachercreatreroomState {
  final dynamic data;

  RoomsDataLoadedFromTheServer({required this.data});
}

part of 'teacherregisterstudent_bloc.dart';

@immutable
abstract class TeacherregisterstudentState {}

class TeacherregisterstudentInitial extends TeacherregisterstudentState {}

class LoadingStudentRegisterData extends TeacherregisterstudentState {}

class LoadedStudentData extends TeacherregisterstudentState {
  final Map<String, dynamic> data;

  LoadedStudentData({required this.data});
}

class TellTeacherOkAnimatedCharacter extends TeacherregisterstudentState {}

class ErrorDuringLoadingStudentData extends TeacherregisterstudentState {
  final String error;

  ErrorDuringLoadingStudentData({required this.error});
}

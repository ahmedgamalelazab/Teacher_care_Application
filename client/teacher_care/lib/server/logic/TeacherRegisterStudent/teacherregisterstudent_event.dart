part of 'teacherregisterstudent_bloc.dart';

@immutable
abstract class TeacherregisterstudentEvent {}

class TeacherRegisterButton extends TeacherregisterstudentEvent {
  final Map<String, dynamic> formData;

  TeacherRegisterButton({required this.formData});
}

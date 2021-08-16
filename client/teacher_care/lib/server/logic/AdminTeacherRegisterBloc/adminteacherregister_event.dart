part of 'adminteacherregister_bloc.dart';

@immutable
abstract class AdminteacherregisterEvent {}

class AdminRegisterTeacher extends AdminteacherregisterEvent {
  final Map<String, dynamic> formBody;

  AdminRegisterTeacher({required this.formBody});
}

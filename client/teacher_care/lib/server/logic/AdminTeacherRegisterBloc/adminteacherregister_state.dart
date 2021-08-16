part of 'adminteacherregister_bloc.dart';

@immutable
abstract class AdminteacherregisterState {}

class AdminteacherregisterInitial extends AdminteacherregisterState {}

//here will be the registering states

//expecting to get registering , registered user , error during registering the user

//this will play the role of the initial state for the first call
class RegisteringTeacherInTheSystem extends AdminteacherregisterState {}

class RegisteredTeacherInTheSystem extends AdminteacherregisterState {
  final Map<String, dynamic> response;

  RegisteredTeacherInTheSystem({required this.response});
}

class RegisteringTeacherInTheSystemERROR extends AdminteacherregisterState {
  final String errorMessage;

  RegisteringTeacherInTheSystemERROR({required this.errorMessage});
}

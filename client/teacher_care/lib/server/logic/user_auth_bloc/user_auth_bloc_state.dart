part of 'user_auth_bloc_bloc.dart';

@immutable
abstract class UserAuthBlocState {}

class UserAuthBlocInitial extends UserAuthBlocState {}

//loading the data from the server
class UserAuthLoading extends UserAuthBlocState {}

//data from the server got loaded

class AdminAuthLogged extends UserAuthBlocState {
  final Map<String, dynamic> data;

  AdminAuthLogged({required this.data});
}

class ModeratorAuthLogged extends UserAuthBlocState {
  final Map<String, dynamic> data;

  ModeratorAuthLogged({required this.data});
}

class TeacherAuthLogged extends UserAuthBlocState {
  final Map<String, dynamic> data;

  TeacherAuthLogged({required this.data});
}

class StudentAuthLogged extends UserAuthBlocState {
  final Map<String, dynamic> data;

  StudentAuthLogged({required this.data});
}

class ParentAuthLogged extends UserAuthBlocState {
  final Map<String, dynamic> data;

  ParentAuthLogged({required this.data});
}

//case of failure

class Auth_FAILED_FOR_NO_REASON extends UserAuthBlocState {
  final String message;

  Auth_FAILED_FOR_NO_REASON({required this.message});
}

//section of update user data after login

//once u hit update user data after login event u will have to wait for a couple seconds to update the whole things
class LoadingUserUpdatedData extends UserAuthBlocState {}

class LoadedUserUpdateProfileData extends UserAuthBlocState {
  final Map<String, dynamic> data;

  LoadedUserUpdateProfileData({required this.data});
}

class UserLoggedOut extends UserAuthBlocState {}

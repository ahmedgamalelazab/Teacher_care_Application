part of 'user_auth_bloc_bloc.dart';

@immutable
abstract class UserAuthBlocEvent {}

class UserLogin extends UserAuthBlocEvent {
  final Map<String, dynamic> body;

  UserLogin({required this.body});
}

class UpdateUserDataAfterLogin extends UserAuthBlocEvent {
  final String userToken;

  UpdateUserDataAfterLogin({required this.userToken});
}

class LogUserOut extends UserAuthBlocEvent {
  final String user_id;

  LogUserOut({required this.user_id});
}

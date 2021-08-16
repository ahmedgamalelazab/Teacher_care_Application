part of 'userutilscontrolscreen_bloc.dart';

@immutable
abstract class UserutilscontrolscreenState {}

class UserutilscontrolscreenInitial extends UserutilscontrolscreenState {}

//initial state when we try to fetch the user data
class UserControlScreenDataLoading extends UserutilscontrolscreenState {}

class UserControlScreenDataLoaded extends UserutilscontrolscreenState {
  final Map<String, dynamic> response;

  UserControlScreenDataLoaded({required this.response});
}

class LoadingUserScreenDataError extends UserutilscontrolscreenState {
  final String errorMessage;

  LoadingUserScreenDataError({required this.errorMessage});
}

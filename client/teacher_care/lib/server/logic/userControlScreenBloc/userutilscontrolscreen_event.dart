part of 'userutilscontrolscreen_bloc.dart';

@immutable
abstract class UserutilscontrolscreenEvent {}

class FetchUserScreenData extends UserutilscontrolscreenEvent {
  final String userToken;

  FetchUserScreenData({required this.userToken});
}

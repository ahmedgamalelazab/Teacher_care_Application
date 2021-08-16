import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repository/userControlScreenDataRepository.dart';

part 'userutilscontrolscreen_event.dart';
part 'userutilscontrolscreen_state.dart';

class UserutilscontrolscreenBloc
    extends Bloc<UserutilscontrolscreenEvent, UserutilscontrolscreenState> {
  final UserUtilsControlScreenRepository userControlScreenRepository;
  UserutilscontrolscreenBloc({required this.userControlScreenRepository})
      : super(UserutilscontrolscreenInitial());

  @override
  Stream<UserutilscontrolscreenState> mapEventToState(
    UserutilscontrolscreenEvent event,
  ) async* {
    if (event is FetchUserScreenData) {
      this.emit(UserControlScreenDataLoading());
      // hold for two seconds
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await userControlScreenRepository
            .fetchControlScreenDataRaw(userToken: event.userToken);
        //if all are ok
        print(response);
        this.emit(UserControlScreenDataLoaded(response: response));
      } catch (error) {
        print(error);
        this.emit(LoadingUserScreenDataError(
            errorMessage: 'dummy message for now !'));
      }
    }
  }
}

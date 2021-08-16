import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_care/utils/js/js_console_log.dart';

import '../../repository/auth_repository.dart';

part 'user_auth_bloc_event.dart';
part 'user_auth_bloc_state.dart';

class UserAuthBlocBloc extends Bloc<UserAuthBlocEvent, UserAuthBlocState> {
  final AuthRepository authRepository;

  UserAuthBlocBloc({required this.authRepository})
      : super(UserAuthBlocInitial());

  @override
  Stream<UserAuthBlocState> mapEventToState(
    UserAuthBlocEvent event,
  ) async* {
    if (event is UserLogin) {
      this.emit(UserAuthLoading());
      await Future.delayed(Duration(seconds: 2));
      try {
        final final_auth_dataRaw =
            await authRepository.user_auth_data_raw(event.body);
        //splitting over the data here
        switch (final_auth_dataRaw['auth_type']) {
          case 'admin':
            this.emit(AdminAuthLogged(data: final_auth_dataRaw['data']));
            Console.log(final_auth_dataRaw['data']);
            break;
          case 'moderator':
            this.emit(ModeratorAuthLogged(data: final_auth_dataRaw['data']));
            Console.log(final_auth_dataRaw['data']);
            break;
          case 'teacher':
            this.emit(TeacherAuthLogged(data: final_auth_dataRaw['data']));
            Console.log(final_auth_dataRaw['data']);
            break;
          case 'student':
            this.emit(StudentAuthLogged(data: final_auth_dataRaw['data']));
            Console.log(final_auth_dataRaw['data']);
            break;
          //TODO IMPLEMETS THE PARENT NEED
          //!THIS DEFAULT WILL BE SET FOR ERROR
          default:
            this.emit(
                Auth_FAILED_FOR_NO_REASON(message: final_auth_dataRaw['data']));
            Console.log(final_auth_dataRaw);
            break;
        }

        // Console.log(final_auth_dataRaw);
      } catch (error) {
        Console.log(error);
        this.emit(Auth_FAILED_FOR_NO_REASON(message: error.toString()));
      }
    } else if (event is UpdateUserDataAfterLogin) {
      //LoadingUserUpdatedData
      //LoadedUserUpdateProfileData
      //i won't wait for now but in application update maybe i will update this and i will wait for it
      this.emit(LoadingUserUpdatedData());
      try {
        final response = await authRepository
            .updateUserDataAfterLoginDataRaw(event.userToken);
        //if all are ok and works
        this.emit(LoadedUserUpdateProfileData(data: response['data']));
      } catch (error) {
        Console.log(error);
        this.emit(Auth_FAILED_FOR_NO_REASON(message: error.toString()));
      }
    } else if (event is LogUserOut) {
      final response = await authRepository.logUserOut(user_id: event.user_id);
      this.emit(UserLoggedOut());
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_care/server/repository/adminTeacherRegisterRepository.dart';

part 'adminteacherregister_event.dart';
part 'adminteacherregister_state.dart';

class AdminteacherregisterBloc
    extends Bloc<AdminteacherregisterEvent, AdminteacherregisterState> {
  AdminTeacherRegisterRepository adminTeacherRegisteringRepository;
  AdminteacherregisterBloc({required this.adminTeacherRegisteringRepository})
      : super(AdminteacherregisterInitial());

  @override
  Stream<AdminteacherregisterState> mapEventToState(
    AdminteacherregisterEvent event,
  ) async* {
    if (event is AdminRegisterTeacher) {
      this.emit(RegisteringTeacherInTheSystem());
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await adminTeacherRegisteringRepository
            .adminTeacherRegisterResponseDataRaw(body: event.formBody);
        //if all are ok
        print(response['data']);
        //if all are ok
        //TODO IMPLEMENT ERROR FROM SERVER ATTACH
        this.emit(RegisteredTeacherInTheSystem(response: response['data']));
      } catch (error) {
        print(error);
      }
    }
  }
}

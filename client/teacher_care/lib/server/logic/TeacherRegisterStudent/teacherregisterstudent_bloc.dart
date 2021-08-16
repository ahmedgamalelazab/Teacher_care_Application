import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_care/server/repository/teacherRegisterStudentRepository.dart';

part 'teacherregisterstudent_event.dart';
part 'teacherregisterstudent_state.dart';

class TeacherregisterstudentBloc
    extends Bloc<TeacherregisterstudentEvent, TeacherregisterstudentState> {
  TeacherRegisterStudentRepository teacherRegisterStudentRepository;

  TeacherregisterstudentBloc({required this.teacherRegisterStudentRepository})
      : super(TeacherregisterstudentInitial());

  @override
  Stream<TeacherregisterstudentState> mapEventToState(
    TeacherregisterstudentEvent event,
  ) async* {
    if (event is TeacherRegisterButton) {
      //do some  code
      this.emit(LoadingStudentRegisterData());
      await Future.delayed(Duration(seconds: 1));
      try {
        final data =
            await teacherRegisterStudentRepository.postStudent(event.formData);
        //if all are ok
        this.emit(TellTeacherOkAnimatedCharacter());
        await Future.delayed(Duration(seconds: 3));
        this.emit(LoadedStudentData(data: data));
      } catch (error) {
        print(error);
      }
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repository/teacher_data_repository.dart';

part 'teacherdata_event.dart';
part 'teacherdata_state.dart';

class TeacherdataBloc extends Bloc<TeacherdataEvent, TeacherdataState> {
  final TeacherDataRepository teacherDataRepository;
  TeacherdataBloc({required this.teacherDataRepository})
      : super(TeacherdataInitial());

  @override
  Stream<TeacherdataState> mapEventToState(
    TeacherdataEvent event,
  ) async* {
    if (event is FetchTeacherData) {
      this.emit(TeacherDataLoading());
      try {
        final teacherData = await teacherDataRepository.teacherDataRaw(
            teacherToken: event.userToken);
        //if all are ok
        print(teacherData);
        this.emit(TeacherDataLoaded(teacherData: teacherData['data']));
      } catch (error) {
        print('error');
      }
    }
  }
}

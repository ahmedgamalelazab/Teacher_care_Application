import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_care/server/repository/TeacherCreateRoomRepository.dart';

part 'teachercreatreroom_event.dart';
part 'teachercreatreroom_state.dart';

class TeachercreatreroomBloc
    extends Bloc<TeachercreatreroomEvent, TeachercreatreroomState> {
  final TeacherCreateRoomRepository teacherCreateRoomRepository;

  TeachercreatreroomBloc({required this.teacherCreateRoomRepository})
      : super(TeachercreatreroomInitial());

  @override
  Stream<TeachercreatreroomState> mapEventToState(
    TeachercreatreroomEvent event,
  ) async* {
    if (event is CreateRoom) {
      this.emit(LoadingCreateRoomEvent());
      await Future.delayed(Duration(seconds: 1));
      try {
        final response =
            await teacherCreateRoomRepository.postStudent(event.formBody);
        //if all are ok
        this.emit(LoadImageAfterLoadingComplete());
        await Future.delayed(Duration(seconds: 1));
        this.emit(TeacherCreateRoomCreated(data: response));
      } catch (error) {
        print(error);
        //! handle the error here
      }
    } else if (event is GetTeacherRooms) {
      this.emit(LoadingTeacherRoomsFromTheServer());
      await Future.delayed(
        Duration(seconds: 2),
      );
      try {
        final dataRawRooms = await teacherCreateRoomRepository.getTeacherRooms(
            teacher_token: event.teacher_token);
        //if every thing are ok
        this.emit(RoomsDataLoadedFromTheServer(data: dataRawRooms));
      } catch (error) {
        print(error);
      }
    }
  }
}

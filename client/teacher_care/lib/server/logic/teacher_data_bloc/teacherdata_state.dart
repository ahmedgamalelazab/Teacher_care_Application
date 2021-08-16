part of 'teacherdata_bloc.dart';

@immutable
abstract class TeacherdataState {}

class TeacherdataInitial extends TeacherdataState {}

class TeacherDataLoading extends TeacherdataState {}

class TeacherDataLoaded extends TeacherdataState {
  final Map<String, dynamic> teacherData;

  TeacherDataLoaded({required this.teacherData});
}

//TODO IMPLEMENTS ERROR CLASS


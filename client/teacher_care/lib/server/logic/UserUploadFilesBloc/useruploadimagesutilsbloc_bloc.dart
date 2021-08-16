import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_care/representation/componets/constant/userUploadImagesUtils.dart';
import 'package:teacher_care/server/repository/userUtilsRepository.dart';

part 'useruploadimagesutilsbloc_event.dart';
part 'useruploadimagesutilsbloc_state.dart';

class UseruploadimagesutilsblocBloc extends Bloc<UseruploadimagesutilsblocEvent,
    UseruploadimagesutilsblocState> {
  //the bloc getting his data from the repository
  final UserUploadImagesUtilsRepository uploadImagesRepository;

  UseruploadimagesutilsblocBloc({required this.uploadImagesRepository})
      : super(UseruploadimagesutilsblocInitial());

  @override
  Stream<UseruploadimagesutilsblocState> mapEventToState(
    UseruploadimagesutilsblocEvent event,
  ) async* {
    if (event is UploadImage) {
      //splitter to identify the upload type to emit a proper state on it
      switch (event.uploadChoice) {
        case UserUploadEnumsUtils.UploadCoverImage:
          try {
            this.emit(LoadingUploadImageProcess());
            //wait for 2 seconds
            await Future.delayed(Duration(seconds: 2));
            final response = await uploadImagesRepository.uploadServiceDataRaw(
                event.data, event.uploadChoice);
            print(response);
            //if all ok
            this.emit(UploadedImage(uploadResponse: response));
          } catch (error) {
            print(error);
            this.emit(FailedOrErroToUpload());
          }
          break;
        case UserUploadEnumsUtils.UploadProfileImage:
          try {
            this.emit(LoadingUploadProfileImageProcess());
            await Future.delayed(Duration(seconds: 2));
            final response = await uploadImagesRepository.uploadServiceDataRaw(
                event.data, event.uploadChoice);
            print(response);
            //if all ok
            this.emit(
                UploadedProfileImageSuccessfully(uploadResponse: response));
          } catch (error) {
            print(error);
            this.emit(FailedOrErroToUpload());
          }
          break;
        default:
      }
    }
  }
}

part of 'useruploadimagesutilsbloc_bloc.dart';

@immutable
abstract class UseruploadimagesutilsblocState {}

class UseruploadimagesutilsblocInitial extends UseruploadimagesutilsblocState {}

//! we will emit this state when we hit the button of upload Image
class LoadingUploadImageProcess extends UseruploadimagesutilsblocState {}

class LoadingUploadProfileImageProcess extends UseruploadimagesutilsblocState {}

class UploadedImage extends UseruploadimagesutilsblocState {
  //! this state have to back to the screen with some data
  final Map<String, dynamic> uploadResponse;

  UploadedImage({required this.uploadResponse});
}

class UploadedProfileImageSuccessfully extends UseruploadimagesutilsblocState {
  final Map<String, dynamic> uploadResponse;

  UploadedProfileImageSuccessfully({required this.uploadResponse});
}

// this will be called and we will load this with error message at the end of application design
class FailedOrErroToUpload extends UseruploadimagesutilsblocState {}

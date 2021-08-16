part of 'useruploadimagesutilsbloc_bloc.dart';

@immutable
abstract class UseruploadimagesutilsblocEvent {}

//when the user tries to upload any Image we will use the same action but with different params

class UploadImage extends UseruploadimagesutilsblocEvent {
  final Map<String, dynamic> data;
  final UserUploadEnumsUtils uploadChoice;

  UploadImage({required this.data, required this.uploadChoice});
}

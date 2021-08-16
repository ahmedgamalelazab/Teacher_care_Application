import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class UserProfileImagePreviewer extends StatefulWidget {
  UserProfileImagePreviewer({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  _UserProfileImagePreviewerState createState() =>
      _UserProfileImagePreviewerState(
        path: path,
      );
}

class _UserProfileImagePreviewerState extends State<UserProfileImagePreviewer> {
  final String path;

  _UserProfileImagePreviewerState({required this.path});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: Image.network(path).image,
      ),
    );
  }
}

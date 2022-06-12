import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageFullScreen extends StatelessWidget {
  final String imagePath;
  const ShowImageFullScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        iconButton: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {}),
      ),
      body: Center(
          child: PhotoView(
        imageProvider: NetworkImage(imagePath),
      )),
    );
  }
}

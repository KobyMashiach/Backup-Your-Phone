import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdfFullScreen extends StatelessWidget {
  final String pdfPath;
  const ShowPdfFullScreen({Key? key, required this.pdfPath}) : super(key: key);

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
        child: SfPdfViewer.network(
          pdfPath,
        ),
      ),
    );
  }
}

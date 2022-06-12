import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdfFullScreen extends StatelessWidget {
  final String pdfPath;
  const ShowPdfFullScreen({Key? key, required this.pdfPath}) : super(key: key);

  // late String path;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfPdfViewer.network(
      pdfPath,
    ));
  }
}

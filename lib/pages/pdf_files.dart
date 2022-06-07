import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:flutter/material.dart';

class PdfFilesPage extends StatelessWidget {
  const PdfFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        icon: const Icon(Icons.file_upload),
        onPressFunction: uploadPdfFiles(),
      ),
      floatingActionButton: const ApplicationFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const ApplicationButtonbar(),
      body: const Text("PDF"),
    );
  }
}

uploadPdfFiles() {}

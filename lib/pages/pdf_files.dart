import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/pages/show_pdf_full_screen.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final user = FirebaseAuth.instance.currentUser;

final path = "${user!.uid}/pdfFiles/";
final ref = FirebaseStorage.instance.ref().child(path);

List<String> pdfFiles = [
  'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'
];

class PdfFilesPage extends StatefulWidget {
  const PdfFilesPage({Key? key}) : super(key: key);

  @override
  State<PdfFilesPage> createState() => _PdfFilesPageState();
}

class _PdfFilesPageState extends State<PdfFilesPage> {
  // Future selectFile(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          iconButton:
              IconButton(onPressed: () {}, icon: const Icon(Icons.file_upload)),
        ),
        floatingActionButton: const ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const ApplicationButtonbar(),
        body: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            // grid view
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {}, //open file check
              child: Card(
                // shape of videos
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white30, width: 3),
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.white12,
                // child: Image.network(
                //   videos[index],
                //   fit: BoxFit.fill,
                //   loadingBuilder: (BuildContext context,
                //       Widget child, // circular until loading
                //       ImageChunkEvent? loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Center(
                //       child: CircularProgressIndicator(
                //         backgroundColor: Colors.white,
                //         value: loadingProgress.expectedTotalBytes != null
                //             ? loadingProgress.cumulativeBytesLoaded /
                //                 loadingProgress.expectedTotalBytes!
                //             : null,
                //       ),
                //     );
                //   },
                // ),

                child: InkWell(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ShowPdfFullScreen(
                          pdfPath: pdfFiles[0],
                        ),
                      ),
                    );
                  },
                  child: PdfViewer.openFutureFile(
                    () async =>
                        (await DefaultCacheManager().getSingleFile(pdfFiles[0]))
                            .path,
                    params: PdfViewerParams(pageNumber: 1),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

Future selectFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.image);

  if (result == null) {
    // List<File> files = result.paths.map((path) => File(path!)).toList();
    ToastMassageShort(msg: "Please pick a file");
    // images = await getFirebaseImageFolder();

    return;
  }
  uploadFiles(context, result.files);
  // openFile(file);
}

Future uploadFiles(BuildContext context, List<PlatformFile> files) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  for (var element in files) {
    final file = File(element.path!);
    final path = "${user!.uid}/images/${element.name}";

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      await ref.putFile(file);
      String fileUrl = await ref.getDownloadURL();
      pdfFiles.add(fileUrl);
      // getFirebaseImageFolder();
    } catch (err) {
      ToastMassageLong(msg: err.toString());
    }
  }
  Navigator.of(context).pop(context);
}

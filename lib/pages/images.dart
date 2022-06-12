// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/provider/get_user.dart';

import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

final path = "${user!.uid}/images/";
final ref = FirebaseStorage.instance.ref().child(path);

// list of all images pathes
List<String> images = [];

// view images page
class ImagesPage extends StatefulWidget {
  const ImagesPage({Key? key}) : super(key: key);
  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          iconButton: IconButton(
              onPressed: () async {
                selectFile(context);
              },
              icon: const Icon(Icons.image_search_rounded)),
        ),
        floatingActionButton: const ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const ApplicationButtonbar(),
        body: const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
          child: LoadImages(),
        ));
  }
}

class LoadImages extends StatefulWidget {
  const LoadImages({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadImages> createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  void updateImages() {
    setState(() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      try {
        images = await getFirebaseImageFolder();
      } catch (err) {
        ToastMassageLong(msg: err.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
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
            // shape of images
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white30, width: 3),
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white12,
            child: Image.network(
              images[index],
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context,
                  Widget child, // circular until loading
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future selectDirectory() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    ToastMassageShort(msg: "Please pick a folder");
    return;
  }
  ToastMassageShort(msg: selectedDirectory);
  var file = File(selectedDirectory);
  return Image.file(file);
}

Future selectFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.image);

  if (result == null) {
    // List<File> files = result.paths.map((path) => File(path!)).toList();
    ToastMassageShort(msg: "Please pick a image");
    images = await getFirebaseImageFolder();

    return;
  }
  uploadFiles(context, result.files);
  // openFile(file);
}

void openFile(PlatformFile file) {
  OpenFile.open(file.path);
}

Future uploadFile(BuildContext context, PlatformFile files) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  final file = File(files.path!);
  final path = "${user!.uid}/images/${files.name}";

  final ref = FirebaseStorage.instance.ref().child(path);

  try {
    await ref.putFile(file);
    String fileUrl = await ref.getDownloadURL();
    images.add(fileUrl);

    // await folderRef.delete();
    Navigator.of(context).pop(context);
    getFirebaseImageFolder();
  } catch (err) {
    ToastMassageLong(msg: err.toString());
    Navigator.of(context).pop(context);
  }
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
      images.add(fileUrl);
      getFirebaseImageFolder();
    } catch (err) {
      ToastMassageLong(msg: err.toString());
    }
  }
  Navigator.of(context).pop(context);
}

Future<List<String>> getFirebaseImageFolder() async {
  List<String> _result = [];
  String url;
  final Reference storageRef =
      FirebaseStorage.instance.ref().child(user!.uid).child('images');
  storageRef.listAll().then((result) async {
    for (var element in result.items) {
      url = await element.getDownloadURL();
      _result.add(url);
    }
  });
  return _result;
}

// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/pages/show_image_full_screen.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

List<String> images = [];

class ImagesPage extends StatefulWidget {
  const ImagesPage({Key? key}) : super(key: key);
  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future:
            getFirebaseImagesFolder(), // check if have images files on firebase => if not view loading
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return Scaffold(
              appBar: ApplicationAppbar(
                title: "Backup Your Phone",
                iconButton: IconButton(
                    onPressed: () {
                      selectFile(context);
                    },
                    icon: const Icon(Icons.image_search_outlined)),
              ),
              floatingActionButton: const ApplicationFloatingActionButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: const ApplicationButtonbar(),
              body: GridView.builder(
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ShowImageFullScreen(
                                // open new page to show the image in full screen
                                imagePath: images[index],
                              ),
                            ),
                          );
                        },
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Scaffold(
                // if don't have images files in firebase
                appBar: ApplicationAppbar(
                  title: "Backup Your Phone",
                  iconButton: IconButton(
                      onPressed: () {
                        selectFile(context);
                      },
                      icon: const Icon(Icons.image_search)),
                ),
                floatingActionButton: const ApplicationFloatingActionButton(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: const ApplicationButtonbar(),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        });
  }
}

Future selectFile(BuildContext context) async {
  // pick file from phone storage (allow just images files)
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.image,
  );

  if (result == null) {
    ToastMassageShort(msg: "Please pick a image");
    return;
  }
  uploadFiles(context, result.files);
}

Future uploadFiles(BuildContext context, List<PlatformFile> files) async {
  // upload the picked files to firebase
  final user = FirebaseAuth.instance.currentUser;

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
    } catch (err) {
      ToastMassageLong(msg: err.toString());
    }
  }
  Navigator.of(context).pop(context);
}

Future<bool> getFirebaseImagesFolder() async {
  // refresh the list to show the updated list
  final user = FirebaseAuth.instance.currentUser;

  images.clear();
  String url;
  final storageRef =
      FirebaseStorage.instance.ref().child(user!.uid).child('images');
  final result = await storageRef.listAll();
  for (var element in result.items) {
    url = await element.getDownloadURL();
    images.add(url);
  }
  return images.isEmpty ? false : true;
}

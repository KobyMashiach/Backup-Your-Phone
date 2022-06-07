// ignore_for_file: avoid_print

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// list of all images pathes
List<String> images = [
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
];

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
                selectDirectory();
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

class LoadImages extends StatelessWidget {
  const LoadImages({
    Key? key,
  }) : super(key: key);

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
        return Card(
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
  } else {
    ToastMassageShort(msg: selectedDirectory);
    var file = new File(selectedDirectory);
    return Image.file(file);
  }
}




// Future selectFile() async {
//   FilePickerResult? result =
//       await FilePicker.platform.pickFiles(allowMultiple: true);

//   if (result != null) {
//     List<File> files = result.paths.map((path) => File(path!)).toList();
//   } else {
//     // User canceled the picker
//   }
// }

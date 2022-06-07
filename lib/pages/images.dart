// ignore_for_file: avoid_print

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/storage_firebase/images_to_firebase.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// list of all images pathes
List<String> images = [
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
  // "https://twsaddlery.com/wp-content/uploads/2015/05/ASC0691-2.jpg",
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
    final Storage storage = Storage();
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          iconButton: IconButton(
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg'],
                );

                if (results == null) {
                  ToastMassageShort(msg: "No File Selected");
                  return;
                }
                final filePath = results.files.single.path!;
                final fileName = results.files.single.name;

                storage.uploadImagesToFB(filePath, fileName).then((value) =>
                    print('Done!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'));
              },
              icon: const Icon(Icons.image_search_rounded)),
        ),
        floatingActionButton: const ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const ApplicationButtonbar(),
        body: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
            // child: LoadImages(),
            // child: FutureBuilder(
            //     future: storage.listImages(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<firebase_storage.ListResult> snapshot) {
            //       // if (snapshot.connectionState == ConnectionState.done &&
            //       //     snapshot.hasData) {
            //       //   return Container();
            //       // }
            //       // if (snapshot.connectionState == ConnectionState.waiting &&
            //       //     snapshot.hasData) {
            //       //   return CircularProgressIndicator();
            //       // }
            //       // images.addAll(snapshot.data!.items[0].fullPath);

            //       // await (await storage.uploadTask.onComplete).ref.getDownloadURL();
            //       images.add(
            //         storage
            //             .downloadUrl(snapshot.data!.items[0].name)
            //             .toString(),
            //       );
            //       return Container();
            //     })

            child: FutureBuilder(
                future: storage.downloadUrl('IMG-20220606-WA0004.jpeg'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Image.network(
                    snapshot.data!,
                  );
                })));
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

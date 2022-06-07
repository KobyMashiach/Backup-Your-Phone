import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

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
class ImagesPage extends StatelessWidget {
  const ImagesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          icon: Icon(Icons.image_search_rounded),
          onPressFunction: uploadImages(),
        ),
        floatingActionButton: ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ApplicationButtonbar(),
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
          child: LoadImages(),
        ));
  }
}

uploadImages() {
  print("");
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
        return Container(
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

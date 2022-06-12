import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:backup_your_phone/pages/contacts.dart';
import 'package:backup_your_phone/pages/images.dart';
import 'package:backup_your_phone/pages/pdf_files.dart';
import 'package:backup_your_phone/pages/videos.dart';
import 'package:flutter/material.dart';

class ApplicationButtonbar extends StatefulWidget {
  const ApplicationButtonbar({
    Key? key,
  }) : super(key: key);

  @override
  State<ApplicationButtonbar> createState() => _ApplicationButtonbarState();
}

class _ApplicationButtonbarState extends State<ApplicationButtonbar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: const [
        Icons.image,
        Icons.play_circle_fill_rounded,
        Icons.contacts_rounded,
        Icons.picture_as_pdf
      ],
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 10,
      rightCornerRadius: 10,
      iconSize: 30,
      activeColor: Colors.black,
      inactiveColor: const Color.fromARGB(255, 151, 151, 151),
      onTap: (index) {
        if (_bottomNavIndex != index) {
          setState(() => _bottomNavIndex = index);
          currectPageRoute(context);
        }
      },
    );
  }
}

void currectPageRoute(context) {
  switch (getBottomNavIndex()) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ImagesPage()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VideosPage()),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()),
      );
      break;
    default:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PdfFilesPage()),
      );
  }
}

/*  icons index
    0 - images
    1 - videos
    2 - contacts
    3 - pdf
*/

var _bottomNavIndex = 0;

int getBottomNavIndex() {
  return _bottomNavIndex;
}

void setBottomNavIndex(int index) {
  _bottomNavIndex = index;
}

class ApplicationFloatingActionButton extends StatelessWidget {
  const ApplicationFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.account_circle_rounded, size: 50),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

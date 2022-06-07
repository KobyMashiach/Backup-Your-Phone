import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/pages/contacts.dart';
import 'package:backup_your_phone/pages/images.dart';
import 'package:backup_your_phone/pages/pdf_files.dart';
import 'package:backup_your_phone/pages/videos.dart';
import 'package:backup_your_phone/provider/google_signin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              user!.photoURL ??
                  "https://cdn1.iconfinder.com/data/icons/basic-app-set/24/user-512.png",
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // showDialog<String>(
              //   context: context,
              //   builder: (BuildContext context) => AlertDialog(
              //     title: const Text('Exit From App'),
              //     content: const Text('Are you sure you want to exit the app?'),
              //     actions: <Widget>[
              //       TextButton(
              //         onPressed: () => Navigator.pop(context),
              //         child: const Text('Cancel'),
              //       ),
              //       TextButton(
              //         onPressed: () => exit(0),
              //         child: const Text('OK'),
              //       ),
              //     ],
              //   ),
              // );
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout From user?'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSigninProvider>(
                            context,
                            listen: false);
                        provider.googleLogout();
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: Text(
                "Welcome ${user.displayName}",
                style: const TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            const Center(
              child: Text(
                "Please choose one of the options",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setBottomNavIndex(0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImagesPage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Circle-icons-camera.svg/768px-Circle-icons-camera.svg.png"),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setBottomNavIndex(1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VideosPage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://icon-library.com/images/video-png-icon/video-png-icon-5.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setBottomNavIndex(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactsPage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbySPOVJMWqKXXDjw9zQLk4k7k7T2xDXjzsw&usqp=CAU"),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setBottomNavIndex(3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PdfFilesPage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://e7.pngegg.com/pngimages/76/273/png-clipart-pdf-logo-portable-document-format-computer-icons-adobe-acrobat-button-red-circle-with-pdf-icon-miscellaneous-text.png"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final user = FirebaseAuth.instance.currentUser;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  List<Contact>? _firebaseContacts;

  get count => null;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await Permission.contacts.request().isGranted) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);

      final path = "${user!.uid}/contacts/vCard";
      final ref = FirebaseStorage.instance.ref().child(path);

      String getVCard = await ref.getDownloadURL();
      downloadFileExample();

      final firebaseContacts = Contact.fromVCard(getVCard);
      setState(() async => _firebaseContacts!.add(firebaseContacts));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          iconButton: IconButton(
              onPressed: () async {
                List<String> vCard = [];
                int count = 0;
                int tempCount = 0;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        content: SizedBox(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 200.0,
                                child: Stack(
                                  children: <Widget>[
                                    const Center(
                                      child: SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "$tempCount/$count",
                                        style: const TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          MaterialButton(
                            child: Text(
                              "Click to refresh",
                            ),
                            onPressed: () {
                              // Navigator.of(context).pop();
                              setState(() {});
                            },
                          )
                        ],
                      );
                    });
                  },
                );
                try {
                  for (var element in _contacts!) {
                    vCard.add(element.toVCard());
                    count++;
                  }

                  String newVCard = "";
                  final path = "${user!.uid}/contacts/vCard";
                  final ref = FirebaseStorage.instance.ref().child(path);

                  for (var i = 0; i < count; i++) {
                    setState(() {
                      tempCount = i;
                    });
                    newVCard += vCard[i];
                  }
                  await ref.putString(newVCard);
                  Navigator.of(context).pop();
                } catch (err) {
                  ToastMassageLong(msg: err.toString());
                  Navigator.of(context).pop();
                }
                // String fileUrl = await ref.getDownloadURL();
              },
              icon: const Icon(Icons.person_add)),
        ),
        floatingActionButton: const ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const ApplicationButtonbar(),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: _body(),
        ));
  }

  Widget _body() {
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              "Permission denied",
              style: TextStyle(fontSize: 30),
            )),
            TextButton(
                onPressed: () async {
                  await Permission.contacts.shouldShowRequestRationale;

                  if (!await Permission.contacts.request().isGranted) {
                    if (await checkChangePremissions() == true) {
                      print(
                          "@@@@@@@##########@@@@@@@@@@@@######@@@@@@@##########@@@@@@@@@@@@######@@@@@@@##########@@@@@@@@@@@@######");
                    }
                  }
                  print(
                      "@@@@@@@##########@@@@@@@@@@@@######@@@@@@@##########@@@@@@@@@@@@######@@@@@@@##########@@@@@@@@@@@@######");

                  if (await Permission.contacts.status.isGranted) {
                    setState(() => _permissionDenied = false);
                  }
                },
                child: const Text(
                    "Please go to setting and allow contact permissions"))
          ],
        ),
      );
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // return ListView.builder(
    //   itemCount: _firebaseContacts!.length,
    //   itemBuilder: (context, i) => ListTile(
    //     title: Text(_firebaseContacts![i].displayName),
    //     leading: _firebaseContacts![i].photo != null
    //         ? CircleAvatar(
    //             backgroundImage: MemoryImage(_firebaseContacts![i].photo!),
    //           )
    //         : const CircleAvatar(
    //             backgroundImage: AssetImage(
    //               "lib/assets/backupYourPhoneLogo.png",
    //             ),
    //           ),
    //     onTap: () async {
    //       final fullContact =
    //           await FlutterContacts.getContact(_firebaseContacts![i].id);
    //       await Navigator.of(context).push(
    //           MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
    //     },
    //   ),
    // );
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(_contacts![i].displayName),
        leading: _contacts![i].photo != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(_contacts![i].photo!),
              )
            : const CircleAvatar(
                backgroundImage: AssetImage(
                  "lib/assets/backupYourPhoneLogo.png",
                ),
              ),
        onTap: () async {
          final fullContact =
              await FlutterContacts.getContact(_contacts![i].id);
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
        },
      ),
    );
  }

  Future<bool> checkChangePremissions() async {
    openAppSettings();
    return await Permission.contacts.status.isGranted ? true : false;
  }
}

Future<void> downloadFileExample() async {
  //First you get the documents folder location on the device...
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  //Here you'll specify the file it should be saved as
  File downloadToFile =
      File('C:/Users/kobko/Dropbox/myApps/backup_your_phone/lib/assets');
  //Here you'll specify the file it should download from Cloud Storage
  String fileToDownload = "${user!.uid}/contacts/vCard.vcf";

  //Now you can try to download the specified file, and write it to the downloadToFile.
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref(fileToDownload)
        .writeToFile(downloadToFile);
  } on firebase_core.FirebaseException catch (e) {}
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  const ContactPage(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          contact.photo != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                  radius: 70,
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage(
                    "lib/assets/backupYourPhoneLogo.png",
                  ),
                  radius: 70,
                ),
          const SizedBox(height: 20),
          Text(
            'First name:\t\t${contact.name.first}',
            style: const TextStyle(fontSize: 25),
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          Text(
            'Last name: ${contact.name.last}',
            style: const TextStyle(fontSize: 25),
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}',
            style: const TextStyle(fontSize: 25),
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}',
            style: const TextStyle(fontSize: 25),
            maxLines: 1,
          ),
        ]),
      ));
}

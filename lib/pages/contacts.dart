import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        iconButton: IconButton(
            onPressed: () {
              uploadContact();
            },
            icon: const Icon(Icons.person_add)),
      ),
      floatingActionButton: const ApplicationFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const ApplicationButtonbar(),
      body: const Text("Contacts"),
    );
  }
}

uploadContact() {}

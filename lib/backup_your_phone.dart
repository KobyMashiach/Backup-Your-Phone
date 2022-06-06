import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:flutter/material.dart';

class BackupYourPhone extends StatelessWidget {
  const BackupYourPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
      ),
      floatingActionButton: ApplicationFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ApplicationButtonbar(),
    );
  }
}

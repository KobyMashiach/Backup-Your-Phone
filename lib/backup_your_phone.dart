import 'package:backup_your_phone/application_appbar.dart';
import 'package:flutter/material.dart';

class BackupYourPhone extends StatelessWidget {
  const BackupYourPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
      ),
    );
  }
}

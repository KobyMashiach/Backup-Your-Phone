import 'package:backup_your_phone/backup_your_phone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/*  remove debug banner
      MaterialApp(
      debugShowCheckedModeBanner: false,
      )
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Backup Your Phone',
      theme: ThemeData.dark(),
      home: const BackupYourPhone(),
    );
  }
}

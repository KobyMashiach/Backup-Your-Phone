import 'package:backup_your_phone/pages/home_page.dart';
import 'package:backup_your_phone/provider/google_signin_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSigninProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Backup Your Phone',
          theme: ThemeData.dark(),
          home: const HomePage(),
        ),
      );
}

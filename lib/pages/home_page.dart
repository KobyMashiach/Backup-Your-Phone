import 'package:backup_your_phone/login_page.dart';
import 'package:backup_your_phone/pages/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const AccountPage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong!'),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/provider/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.phone_android_outlined,
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(150), // Image radius
                  child: Image.asset(
                    "lib/assets/backupYourPhoneLogo.png",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          const LoginWithGoogle(),
        ],
      ),
    );
  }
}

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      onPressed: () async {
        final provider =
            Provider.of<GoogleSigninProvider>(context, listen: false);
        provider.googleLogin();
      },
    );
  }
}

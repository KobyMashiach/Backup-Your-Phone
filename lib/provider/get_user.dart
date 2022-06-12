import 'package:firebase_auth/firebase_auth.dart';

// final user = FirebaseAuth.instance.currentUser;
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

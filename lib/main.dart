import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:my_karaoke/screens/launch_screen.dart';
import 'package:my_karaoke/shared/data_provider.dart';
import 'package:my_karaoke/ui/init.dart';
import 'package:my_karaoke/ui/splash.dart';
import 'shared/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // testData();
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          return MultiProvider(
            providers: [
              StreamProvider<firebaseAuth.User?>.value(
                value: firebaseAuth.FirebaseAuth.instance.authStateChanges(),
                initialData: null,
              ),
              ChangeNotifierProvider<AuthProvider>(
                  create: (context) => AuthProvider()),
              ChangeNotifierProvider(
                create: (_) => DataList(),
              )
            ],
            child: MaterialApp(
              title: 'Events',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              home: LaunchScreen(),
            ),
          );
        }
      },
    );
  }
}

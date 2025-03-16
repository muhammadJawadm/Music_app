import 'package:flutter/material.dart';
import 'package:music_app/Favourite_provider.dart';
import 'package:music_app/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_app/MainPage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Use this if `firebase_options.dart` is generated
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FavouriteSongsProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainHomePage(),
    );
  }
}

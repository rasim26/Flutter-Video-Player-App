import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_video_player_with_hive/database/db.dart';
import 'package:local_video_player_with_hive/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VideoDatabase.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

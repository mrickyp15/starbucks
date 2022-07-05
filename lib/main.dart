import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starbucks/providers/todo_list_provider.dart';
import 'package:starbucks/utils/notification_handler.dart';
import 'package:starbucks/views/Homepage.dart';
import 'package:starbucks/views/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starbucks/views/premium_page.dart';
import 'package:starbucks/widgets/create_menu.dart';
import 'package:starbucks/widgets/update_menu.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Starbucks",
        home: LoginPage(),
        routes: {
          'home': (context) =>  HomeScreen(),
          'create': (context) => const Createfriends(),
          'update': (context) => const Updatefriends()
        },
      ),
    );
  }
}
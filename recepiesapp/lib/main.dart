import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:recepiesapp/ui/view/mysplashscreen.dart';

import 'core/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthorizationService>(
      create: (_) => AuthorizationService(),
      child: GetMaterialApp(
        title: "food app",
        theme: ThemeData(primarySwatch: Colors.orange),
        home: MySplashScreen(),
      ),
    );
  }
}

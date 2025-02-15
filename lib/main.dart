import 'package:flutter/material.dart';
import '../views/home_view.dart';
import 'app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await initializeServiceLocator();
  runApp(const MyApp());
}

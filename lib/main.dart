import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_book/view_model/profile_view_model.dart';
import 'package:razor_book/view_model/shop_view_model.dart';
import 'package:razor_book/views/root_view.dart';
import 'app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await initializeServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => localStorageServiceProvider
              ..readUID()
              ..readCusProfile()),
        ChangeNotifierProvider(
          create: (context) => ShopViewModelProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ProfileViewModelProvider()),
      ],
      child: const MaterialApp(
        home: RootView(),
      ),
    );
  }
}

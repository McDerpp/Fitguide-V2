import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/login.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  // //   statusBarColor: Colors.transparent, 
  // //   systemNavigationBarColor:
  // //       Colors.transparent,
  // // ));
  runApp(const ProviderScope(child: MyApp()));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      navigatorObservers: [routeObserver],
    );
  }
}

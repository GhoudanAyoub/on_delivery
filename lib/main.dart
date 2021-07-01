import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/services/user_service.dart';
import 'package:on_delivery/utils/providers.dart';
import 'package:on_delivery/utils/routes.dart';
import 'package:on_delivery/utils/theme.dart';
import 'package:provider/provider.dart';

import 'SplashScreen/splash_screen.dart';
import 'components/life_cycle_event_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () => UserService().setUserStatus(false),
      resumeCallBack: () => UserService().setUserStatus(true),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OnDelivery',
          theme: theme(),
          initialRoute: SplashScreen.routeName,
          routes: routes,
        ));
  }
}

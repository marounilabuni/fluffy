//13:00
import 'package:flutter/material.dart';
import 'package:food_menu/backend/firebase/firestore_agent.dart';
import 'package:food_menu/backend/firebase/realtime_agent.dart';
import 'package:food_menu/backend/product/product.dart';
import 'package:food_menu/constants.dart';
import 'package:food_menu/fluffy/admin/fluffy_page_admin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initContants();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FireStoreAgent.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluffy',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: CardTheme(surfaceTintColor: Colors.transparent),

        
      ),

      ///
      ///
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      locale: const Locale('he'),
      supportedLocales: const [
        Locale('he'),
        Locale('ar'),
        Locale('en'),
      ],
      // Define the initial route
      initialRoute: '/',
      // Define the available named routes
      routes: {
        '/': (context) => FluffyPageAdmin(
              isAdmin: false,
            ),
        'admin': (context) => FluffyPageAdmin(
              isAdmin: true,
            ),
        '/admin': (context) => FluffyPageAdmin(
              isAdmin: true,
            ),
      },
      onGenerateRoute: (settings) {
        switch (settings.name.toString().toLowerCase()) {
          case '/':
            return MaterialPageRoute<void>( 
              builder: (_) => FluffyPageAdmin(
                isAdmin: false,
              ),
            );
          case '/home':
            return MaterialPageRoute<void>(
              builder: (_) => FluffyPageAdmin(
                isAdmin: false,
              ),
            );
          case '/admin':
            return MaterialPageRoute<void>(
              builder: (_) => FluffyPageAdmin(
                isAdmin: true,
              ),
            );

          default:
            return MaterialPageRoute<void>(
              builder: (_) => FluffyPageAdmin(
                isAdmin: false,
              ),
            );
        }
      },
    );
  }
}

//13:00
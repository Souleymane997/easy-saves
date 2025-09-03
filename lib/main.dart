import 'package:easy_saves/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'launch.dart';
import 'network_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final connectivityService = ConnectivityService();// connection check

  runApp( MyApp(connectivityService));
}


class MyApp extends StatelessWidget {

  const MyApp(this.connectivityService, {super.key});
  final ConnectivityService connectivityService;

  Future<bool> checkTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('termsAccepted') ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: connectivityService.navigatorKey,
      //home: const LaunchPage(),
      home: FutureBuilder<bool>(
        future: checkTermsAccepted(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.data == true) {
            return const  LaunchPage(); // ta page principale
          } else {
            return TermsAndConditionsPage(onAccepted: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('termsAccepted', true);
              // Redémarrer app ou naviguer vers la page principale
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LaunchPage()),
              );
            });
          }
        },
      ),

      builder: (context, child) {
        connectivityService.initialize();
        return child!;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


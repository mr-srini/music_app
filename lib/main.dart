import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nymble_music_app/firebase_options.dart';
import 'package:nymble_music_app/src/config/router/app_router.dart';
import 'package:nymble_music_app/src/config/themes/app_themes.dart';
import 'package:nymble_music_app/src/presentation/providers/song_provider.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';
import 'package:nymble_music_app/src/utils/resources/firestore.dart';
import 'package:nymble_music_app/src/utils/resources/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HiveService.init();

  await Firestore.syncDataFromHiveToFirebase();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    appRouter.refresh();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SongProvider>(
            create: (context) => SongProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      child: ChangeNotifierProvider<ThemeProvider>(
          create: (cxt) => ThemeProvider(),
          builder: (context, _) {
            return MaterialApp.router(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              theme: Provider.of<ThemeProvider>(context).isDark
                  ? AppTheme.dark
                  : AppTheme.light,
            );
          }),
    );
  }
}

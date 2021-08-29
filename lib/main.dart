import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/dictionary.dart';
import './screens/main_screen.dart';
import './screens/settings_screen.dart';
import 'screens/my_dictionary_screen.dart';
import './screens/edit_vocabulary_screen.dart';
import './config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Dictionary()),
        ChangeNotifierProvider(create: (ctx) => Config()),
      ],
      child: MaterialApp(
        title: 'Remember',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                headline2: TextStyle(
                  // color: Colors.grey[300]!.withOpacity(0.3);
                  fontWeight: FontWeight.w400,
                ),
                headline3: TextStyle(
                  // color: Colors.white12,
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
                subtitle1: TextStyle(
                  // color: Colors.white24,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
        ),
        // initialRoute: SettingsScreen.routeName,
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          MyDictionaryScreen.routeName: (ctx) => MyDictionaryScreen(),
          EditVocabularyScreen.routeName: (ctx) => EditVocabularyScreen(),
        },
      ),
    );
  }
}

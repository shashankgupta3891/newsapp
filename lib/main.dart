import 'package:flutter/material.dart';
import 'package:newsapp/core/theme/theme.dart';
import 'package:newsapp/presentation/screens/display_news_screen.dart';
import 'package:newsapp/provider/provider_scr.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/search_news.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args =
    // ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
          create: (BuildContext context) => NewsProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (BuildContext context) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        theme: lightThemeData,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          DisplayNewsScreen.routeName: (context) => DisplayNewsScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == DisplayNewsScreen.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return DisplayNewsScreen();
              },
            );
          }

          return null;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newsapp/core/model/article_model.dart';
import 'package:newsapp/core/theme/theme.dart';
import 'package:newsapp/presentation/screens/display_news_screen.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:provider/provider.dart';

import 'data_repository/local/countries.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/search_news.dart';

void main() {
  runApp(MyApp());
}

// MaterialColor createMaterialColor(Color color) {
//   List strengths = <double>[.05];
//   Map swatch = <int, Color>{};
//   final int r = color.red, g = color.green, b = color.blue;

//   for (int i = 1; i < 10; i++) {
//     strengths.add(0.1 * i);
//   }
//   strengths.forEach((strength) {
//     final double ds = 0.5 - strength;
//     swatch[(strength * 1000).round()] = Color.fromRGBO(
//       r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//       g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//       b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//       1,
//     );
//   });
//   return MaterialColor(color.value, swatch);
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args =
    // ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
            create: (BuildContext context) => NewsProvider())
      ],
      child: MaterialApp(
        theme: lightThemeData,
        // home: HomeScreen(c: c),
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

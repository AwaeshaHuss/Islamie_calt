import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_calt/pages/searchedList.dart';
import 'package:islamic_calt/pages/genre_vedio.dart';
import 'package:islamic_calt/pages/home.dart';
import 'package:islamic_calt/pages/movies_series.dart';
import 'package:islamic_calt/pages/ms_list.dart';
import 'package:islamic_calt/pages/reg_login.dart';
import 'package:islamic_calt/pages/show.dart';
import 'package:islamic_calt/pages/intro_screen.dart';
import 'package:islamic_calt/pages/user_prfile.dart';
import 'package:islamic_calt/pages/vedio_player.dart';

// our title is no need for complication
main() {
  EasyLocalization.ensureInitialized(); // initialize localization
  runApp(EasyLocalization(
      // wrap MyApp Widget in EasyLocalization Widget with it's params.
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'JO')],
      path: 'assets/langs',
      saveLocale: true,
      fallbackLocale: Locale('ar', 'JO'),
      startLocale: Locale('ar', 'JO'),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // set app orietation to portrait

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      title: 'Islamic Culture'.tr(),
      initialRoute: 'intro_screen', // lunch the app from the intro screen
      routes: {
        'intro_screen': (context) => IntroScreen(),
        'regLog_page': (context) => RegLogin(),
        'home_page': (context) => Home(),
        'ms_page': (context) => MSList(),
        'user_profile_page': (context) => UserProfile(),
        'movies_page': (context) => MoviesPage(),
        'show_page': (context) => ShowPage(),
        'vedio_player': (context) => VedioPlayer(),
        'genre_vedio_player': (context) => GenreVedioPlayer(),
        'searched_list': (context) => SearchedList()
      },
    );
  }
}

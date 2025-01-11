import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../features/notes/data/datasources/notes_local_datasource.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/presentation/providers/language_provider.dart';
import '../../features/notes/presentation/providers/notes_provider.dart';
import '../../features/notes/presentation/screens/home_screen.dart';
import '../theme/app_theme.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  _MyAppState createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.prefs.getString('language_code') ?? 'en');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    widget.prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesProvider(
            NotesRepositoryImpl(
              NotesLocalDataSourceImpl(),
            ),
          )..loadNotes(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(widget.prefs),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale, // Use the current locale
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

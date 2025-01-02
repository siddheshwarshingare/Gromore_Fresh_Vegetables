import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sales_rep/dashboard.dart';
import 'package:sales_rep/historyPage.dart';
import 'package:sales_rep/loginScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart'; // Import provider package

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(), // Provide the LocaleProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current locale from LocaleProvider
    final locale = Provider.of<LocaleProvider>(context).locale;

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('te'), // Telugu (add more as needed)
      ],
      locale: locale, // Set the current locale
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Loginscreen(), // Login screen as the entry point
    );
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // Default language is English

  Locale get locale => _locale;

  void changeLanguage(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners(); // Notify listeners when the locale changes
    }
  }
}

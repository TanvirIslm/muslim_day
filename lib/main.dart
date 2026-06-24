import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/quran_settings.dart';
import 'providers/prayer_settings.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bn_BD', null);

  // Forces the status bar to match your brand green
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF1D9375),
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuranSettings()),
        ChangeNotifierProvider(create: (context) => PrayerSettings()),
      ],
      child: const MuslimDayApp(),
    ),
  );
}

class MuslimDayApp extends StatelessWidget {
  const MuslimDayApp({super.key});

  static const Color appBrandColor = Color(0xFF1D9375);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (themeProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator(color: appBrandColor))),
          );
        }

        return MaterialApp(
          title: 'Muslim Day',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,

          // --- LIGHT THEME ---
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: appBrandColor,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            fontFamily: GoogleFonts.notoSansBengali().fontFamily,
            appBarTheme: const AppBarTheme(
              backgroundColor: appBrandColor,
              elevation: 4,
              foregroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: appBrandColor,
              secondary: appBrandColor,
              surface: Colors.white,
            ),
          ),

          // --- DARK THEME ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: appBrandColor,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: GoogleFonts.notoSansBengali().fontFamily,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              elevation: 4,
              foregroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.dark(
              primary: appBrandColor,
              secondary: appBrandColor,
              surface: Color(0xFF1F1F1F),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (themeProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF1D9375)),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'Muslim Day',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          
          // Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            primaryColor: const Color(0xFF1A4D4D),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            fontFamily: GoogleFonts.notoSansBengali().fontFamily,
            
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1A4D4D),
              elevation: 4,
              foregroundColor: Colors.white,
              titleTextStyle: GoogleFonts.notoSansBengali(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            cardTheme: const CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              color: Colors.white,
            ),
            
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A4D4D),
              secondary: Color(0xFF1D9375),
              surface: Colors.white,
              error: Colors.red,
            ),
          ),
          
          // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            primaryColor: const Color(0xFF1D9375),
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: GoogleFonts.notoSansBengali().fontFamily,
            
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1F1F1F),
              elevation: 4,
              foregroundColor: Colors.white,
              titleTextStyle: GoogleFonts.notoSansBengali(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            cardTheme: const CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              color: Color(0xFF1F1F1F),
            ),
            
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1D9375),
              secondary: Color(0xFF4DB6AC),
              surface: Color(0xFF1F1F1F),
              error: Colors.redAccent,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
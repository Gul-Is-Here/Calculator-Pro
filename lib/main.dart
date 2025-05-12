// main.dart
import 'package:calculator_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/calculator_view.dart';
import 'views/history_view.dart';
import 'views/scientific_view.dart';
import 'views/settings_view.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Calculator Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF4A47A3),
          background: Color(0xFFF5F5F5),
          surface: Colors.white,
          onBackground: Colors.black,
          onSurface: Colors.black,
          onPrimary: Colors.white,
          error: Color(0xFFFF6B6B),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF4A47A3),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF4A47A3),
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
          onBackground: Colors.white,
          onSurface: Colors.white,
          onPrimary: Colors.white,
          error: Color(0xFFFF6B6B),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<Widget> _pages = [
    CalculatorView(),
    ScientificView(),
    HistoryView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = 0.obs;

    return Scaffold(
      body: Obx(() => _pages[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomNavigationBar(
              currentIndex: currentIndex.value,
              onTap: (index) => currentIndex.value = index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Get.theme.colorScheme.surface,
              selectedItemColor: Get.theme.colorScheme.primary,
              unselectedItemColor: Get.theme.colorScheme.onSurface.withOpacity(
                0.6,
              ),
              selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate_outlined),
                  activeIcon: Icon(Icons.calculate),
                  label: 'Basic',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.science_outlined),
                  activeIcon: Icon(Icons.science),
                  label: 'Scientific',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

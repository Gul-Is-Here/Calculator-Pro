import 'package:calculator_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          primary: Color(0xFFFA980B), // Vibrant orange
          secondary: Color.fromARGB(255, 139, 196, 250), // Modern purple accent
          background: Color(0xFFF8FAFC), // Soft off-white
          surface: Color(0xFFFFFFFF),
          onBackground: Color(0xFF1E293B), // Deep slate for text
          onSurface: Color(0xFF1E293B),
          onPrimary: Color(0xFF1E293B), // Dark text for contrast on orange
          error: Color(0xFFF43F5E), // Modern rose error
        ),
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Color(0xFF1E293B),
          displayColor: Color(0xFF1E293B),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1E293B),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFA980B), // Vibrant orange
          secondary: Color.fromARGB(
            255,
            139,
            196,
            250,
          ), // Light purple accent (fixed from 0xFFA980A)
          background: Color(0xFF0F172A), // Deep slate background
          surface: Color(0xFF1E293B), // Darker surface
          onBackground: Color(0xFFE2E8F0), // Light slate for text
          onSurface: Color(0xFFE2E8F0),
          onPrimary: Color(0xFF1E293B), // Dark text for contrast on orange
          error: Color(0xFFF87171), // Softer rose for errors
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: Color(0xFFE2E8F0), displayColor: Color(0xFFE2E8F0)),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFE2E8F0),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        scaffoldBackgroundColor: Color(0xFF0F172A),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
            gradient: LinearGradient(
              colors: [
                Get.theme.colorScheme.surface,
                Get.theme.colorScheme.surface.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomNavigationBar(
              currentIndex: currentIndex.value,
              onTap: (index) => currentIndex.value = index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Get.theme.colorScheme.primary,
              unselectedItemColor: Get.theme.colorScheme.onSurface.withOpacity(
                0.5,
              ),
              selectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate_outlined, size: 28),
                  activeIcon: Icon(Icons.calculate, size: 28),
                  label: 'Basic',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.science_outlined, size: 28),
                  activeIcon: Icon(Icons.science, size: 28),
                  label: 'Scientific',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined, size: 28),
                  activeIcon: Icon(Icons.history, size: 28),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined, size: 28),
                  activeIcon: Icon(Icons.settings, size: 28),
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

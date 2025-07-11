import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  final ThemeController _controller = Get.put(ThemeController());
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => SwitchListTile(
      title: Text(
        _controller.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
        style: Get.textTheme.bodyLarge,
      ),
      secondary: Icon(
        _controller.isDarkMode.value ? Icons.nightlight_round : Icons.wb_sunny,
      ),
      value: _controller.isDarkMode.value,
      onChanged: (value) => _controller.toggleTheme(),
    ));
  }
}
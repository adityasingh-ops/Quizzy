import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xFF2E073F); // Dark Purple
  static Color get primaryColor2 => const Color.fromARGB(255, 88, 20, 125); // Medium Purple

  static Color get secondaryColor1 => const Color.fromARGB(255, 79, 6, 119); // Light Purple
  static Color get secondaryColor2 => const Color(0xFFEBD3F8); // Very Light Purple

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xFF1D1617);
  static Color get gray => const Color(0xFF786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xFFF7F8F8);

  // Additional colors for dark theme
  static Color get darkBackground => const Color.fromARGB(255, 38, 38, 38);
  static Color get darkSurface => const Color(0xFF2C2C2C);
  static Color get darkText => Colors.white;
  static Color get darkTextSecondary => const Color(0xFFB3B3B3);
}
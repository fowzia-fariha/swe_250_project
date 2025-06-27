import 'package:flutter/material.dart';

/// Centralized color definitions for the app.
class AppColors {
  /// Soft pastel orange used as the main background color.
  static const Color bgColor = Color(0xFFFFE0B2);

  /// Warm orange used for selections and accents.
  static const Color selectionColor = Color(0xFFFFAB91);

  /// White background for cards and dialogs.
  static const Color cardBackground = Colors.white;

  /// Light grey for unselected states and borders.
  static const Color greyLight = Color(0xFFF5F5F5);

  /// Dark grey for text and icons.
  static const Color greyDark = Color(0xFF424242);

  /// Primary swatch fallback.
  static const MaterialColor primarySwatch = Colors.orange;

  static var primaryColor;
}

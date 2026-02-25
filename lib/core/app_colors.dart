import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===== BRAND / ACCENT =====
  // Màu nhấn chung (nếu còn dùng #3A7DFF)
  static const Color brand = Color(0xFF3A7DFF);
  static const Color secondaryText = Color(0xFF8F9BB3);
  static const Color darkText = Color(0xFF222B45);
  static const Color calendarDot = Color(0xFF6D29F6);
  static const Color calendarSelection = Color(0xFF3A7DFF);

  // ===== PRIMARY (AUTH / CTA) =====
  static const Color primary = Color(0xFF0095FF);
  static const Color primarySoft = Color.fromARGB(255, 224, 243, 255);

  // ===== BACKGROUND / SURFACE =====
  static const Color background = Color(0xFFEBEBEB);
  static const Color surface = Color(0xFFFFFFFF);

  // ===== TEXT (GLOBAL) =====
  static const Color textPrimary = Color(0xFF202020);
  static const Color textSecondary = Color(0xFF606060);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // ===== TEXT (AUTH) =====
  static const Color authText = Color(0xFF333333);

  // ===== BORDER / DIVIDER =====
  static const Color border = Color(0xFFDADADA);

  // ===== STATUS =====
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
}

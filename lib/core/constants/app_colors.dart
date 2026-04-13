// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Colors ─────────────────────────
  static const primary = Color(0xFF1B5E20);      // Hijau tua
  static const primaryLight = Color(0xFF4CAF50); // Hijau muda
  static const primaryDark = Color(0xFF003300);  // Hijau gelap

  // ── Category Colors ───────────────────────
  static const personal = Color(0xFF1565C0);    // Biru — Uang Pribadi
  static const shared = Color(0xFF6A1B9A);      // Ungu — Tabungan Bersama
  static const emergency = Color(0xFFE65100);   // Oranye — Dana Darurat

  // ── Transaction Colors ────────────────────
  static const income = Color(0xFF2E7D32);      // Hijau
  static const expense = Color(0xFFC62828);     // Merah
  static const transfer = Color(0xFF1565C0);    // Biru

  // ── Status Colors ─────────────────────────
  static const active = Color(0xFFF57F17);      // Kuning — masih berjalan
  static const settled = Color(0xFF2E7D32);     // Hijau — lunas
  static const writeOff = Color(0xFF757575);    // Abu — dihapus

  // ── Neutral ───────────────────────────────
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const divider = Color(0xFFE0E0E0);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textHint = Color(0xFFBDBDBD);
}
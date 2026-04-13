// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // 1. IMPORT PACKAGE BARU

import 'core/utils/preferences_helper.dart';
import 'app.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() async {
  // 2. SIMPAN WIDGET BINDING
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 3. TAHAN SPLASH SCREEN
  // Mencegah blank putih/hitam selama proses await di bawahnya berjalan
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('id_ID', null);

  // Cek apakah onboarding sudah dilakukan (memakan waktu beberapa milidetik)
  final onboardingDone = await PreferencesHelper.isOnboardingDone();

  // 4. HAPUS SPLASH SCREEN
  // Proses ambil data lokal selesai, saatnya memunculkan UI ke pengguna
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: onboardingDone
          ? const FintrackApp()
          : OnboardingWrapper(
              onDone: () => runApp(
                const ProviderScope(
                  child: FintrackApp(),
                ),
              ),
            ),
    ),
  );
}

/// Wrapper untuk menangani transisi dari onboarding ke app utama
class OnboardingWrapper extends StatelessWidget {
  final VoidCallback onDone;

  const OnboardingWrapper({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
        ),
      ),
      home: OnboardingScreen(
        onDone: onDone,
      ),
    );
  }
}
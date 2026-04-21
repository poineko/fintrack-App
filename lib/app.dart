// lib/app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/internal_debt/screens/kasbon_list_screen.dart';
import 'features/transactions/screens/transaction_list_screen.dart';
import 'features/wallets/screens/wallet_list_screen.dart';
import 'features/receivables/screens/receivable_list_screen.dart';
import 'features/debts/screens/debt_list_screen.dart';

// ─────────────────────────────────────────────
// ROUTER
// ─────────────────────────────────────────────

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/wallets',
          builder: (context, state) => const WalletListScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionListScreen(),
        ),
        GoRoute(
          path: '/kasbon',
          builder: (context, state) => const KasbonListScreen(),
        ),
        GoRoute(
          path: '/debts',
          builder: (context, state) => const DebtListScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/receivables',
          builder: (context, state) => const ReceivableListScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
      ],
    ),
  ],
);

// ─────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────

class FintrackApp extends StatelessWidget {
  const FintrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ── Card konsisten ────────────────────
        cardTheme: CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero, // ← Biarkan parent yang atur margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.surface,
        ),
        // ── Input konsisten ───────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        // ── Button konsisten ──────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // ── Divider konsisten ─────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        // ── ListTile konsisten ────────────────
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SCAFFOLD — Bottom Navigation
// ─────────────────────────────────────────────

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<String> _routes = [
    '/dashboard',
    '/wallets',
    '/transactions',
    '/kasbon',
    '/receivables',
    '/debts',
    '/analytics',
  ];

  int _locationToIndex(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/wallets')) return 1;
    if (location.startsWith('/transactions')) return 2;
    if (location.startsWith('/kasbon')) return 3;
    if (location.startsWith('/receivables')) return 4;
    if (location.startsWith('/debts')) return 5;
    if (location.startsWith('/analytics')) return 6;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      extendBody: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ── Konten halaman ──────────────
            widget.child,

            // ── Swipe zone KIRI (tepi kanan layar → next) ──
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 40, // ← Hanya 24px dari tepi kanan
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) < -300) {
                    if (currentIndex < _routes.length - 1) {
                      context.go(_routes[currentIndex + 1]);
                    }
                  }
                },
              ),
            ),

            // ── Swipe zone KANAN (tepi kiri layar → prev) ──
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 40, // ← Hanya 24px dari tepi kiri
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) > 300) {
                    if (currentIndex > 0) {
                      context.go(_routes[currentIndex - 1]);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onTap(context, index),
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
          // ← Sembunyikan semua label
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          elevation: 8,
          height: 56, // ← Lebih compact karena tidak ada label
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Beranda', // ← Tetap ada tapi tidak tampil
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet),
              label: 'Dompet',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Transaksi',
            ),
            NavigationDestination(
              icon: Icon(Icons.swap_horiz_outlined),
              selectedIcon: Icon(Icons.swap_horiz),
              label: 'Kasbon',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance),
              label: 'Piutang',
            ),
            NavigationDestination(
              icon: Icon(Icons.credit_card_outlined),
              selectedIcon: Icon(Icons.credit_card),
              label: 'Hutang',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Analitik',
            ),
          ],
        ),
      ),
    );
  }
}

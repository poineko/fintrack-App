// lib/features/analytics/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import '../widgets/expense_table.dart';
import '../widgets/monthly_comparison.dart';
import '../../../core/utils/preferences_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analitik'),
        actions: [
          // ← TAMBAH tombol reset onboarding untuk testing
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Reset Onboarding',
            onPressed: () async {
              await PreferencesHelper.resetOnboarding();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Onboarding direset. Restart app untuk melihat.'),
                  ),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Perbandingan'),
            Tab(text: 'Tabel Histori'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Perbandingan & Tren
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: const [
              MonthlyComparison(),
            ],
          ),

          // Tab 2: Tabel Histori
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: const [
              ExpenseTable(),
            ],
          ),
        ],
      ),
    );
  }
}

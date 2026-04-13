// lib/core/constants/app_strings.dart
class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────
  static const appName = 'Fintrack';

  // ── Navigation ────────────────────────────
  static const navDashboard = 'Dashboard';
  static const navWallets = 'Dompet';
  static const navTransactions = 'Transaksi';
  static const navKasbon = 'Kasbon';
  static const navMore = 'Lainnya';

  // ── Wallet Categories ─────────────────────
  static const categoryPersonal = 'Uang Pribadi';
  static const categoryShared = 'Tabungan Bersama';
  static const categoryEmergency = 'Dana Darurat';

  // ── Transaction Types ─────────────────────
  static const typeIncome = 'Pemasukan';
  static const typeExpense = 'Pengeluaran';
  static const typeTransfer = 'Transfer';

  // ── Status ────────────────────────────────
  static const statusActive = 'Aktif';
  static const statusSettled = 'Lunas';
  static const statusPartial = 'Sebagian';
  static const statusWriteOff = 'Dihapus';

  // ── Common ────────────────────────────────
  static const save = 'Simpan';
  static const cancel = 'Batal';
  static const delete = 'Hapus';
  static const edit = 'Edit';
  static const confirm = 'Konfirmasi';
  static const loading = 'Memuat...';
  static const errorGeneral = 'Terjadi kesalahan. Coba lagi.';
  static const noData = 'Belum ada data';

  // ── Onboarding ────────────────────────────
  static const onboardingDoneKey = 'onboarding_done';

  static const onboarding1Title = 'Kelola Keuangan\ndengan Mudah';
  static const onboarding1Desc =
      'Pantau semua saldo dompet Anda — uang pribadi, tabungan bersama, dan dana darurat dalam satu aplikasi.';

  static const onboarding2Title = 'Catat Setiap\nTransaksi';
  static const onboarding2Desc =
      'Catat pemasukan dan pengeluaran dengan mudah. Pilih sumber dana, kategori, dan lihat histori kapan saja.';

  static const onboarding3Title = 'Kelola Kasbon\n& Piutang';
  static const onboarding3Desc =
      'Fitur kasbon membantu Anda meminjam dari tabungan bersama dan melunasi secara bertahap. Piutang ke orang lain pun tercatat rapi.';

  static const onboarding4Title = 'Analisis Keuangan\nBulanan';
  static const onboarding4Desc =
      'Lihat tren pengeluaran, perbandingan bulan ini vs lalu, dan rasio tabungan untuk keputusan keuangan yang lebih baik.';
}

// lib/core/constants/enums.dart

enum WalletCategory {
  personal,   // Uang Pribadi
  shared,     // Tabungan Bersama
  emergency,  // Uang Jaga-jaga / Darurat
}

enum TransactionType {
  income,
  expense,
  transfer,
}

enum TransactionCategory {
  food,
  transport,
  shopping,
  bills,
  health,
  entertainment,
  education,
  salary,
  freelance,
  investment,
  gift,
  refund,
  internalDebtBorrow,
  internalDebtRepayment,
  receivableGiven,
  receivableCollection,
  other,
}

enum InternalDebtStatus {
  active,
  partiallyPaid,
  settled,
}

enum ReceivableStatus {
  active,
  partiallyCollected,
  collected,
  writeOff,
}
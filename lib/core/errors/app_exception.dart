// lib/core/errors/app_exception.dart
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' ($code)' : ''}';
}

// ❌ const tidak bisa pakai interpolasi parameter
// ✅ Hapus const, pakai constructor biasa
class InsufficientBalanceException extends AppException {
  InsufficientBalanceException(String walletName, double balance)
      : super('Saldo $walletName tidak cukup (${balance.toStringAsFixed(0)})');
}

class WalletNotFoundException extends AppException {
  WalletNotFoundException(int id) : super('Wallet tidak ditemukan (id: $id)');
}

class DebtAlreadySettledException extends AppException {
  const DebtAlreadySettledException() : super('Kasbon ini sudah lunas');
}

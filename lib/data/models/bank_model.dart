class Bank {
  Bank({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.bankName,
    required this.isBusinessAccount,
  });
  String id;
  final String accountNumber;
  final String accountType;
  final String bankName;
  final bool isBusinessAccount;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json['id'],
        accountNumber: json['account_number'],
        accountType: json['account_type'],
        bankName: json['bank_name'],
        isBusinessAccount: json['is_business_account'],
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'account_number': accountNumber,
        'account_type': accountType,
        'bank_name': bankName,
        'is_business_account': isBusinessAccount,
      };
}

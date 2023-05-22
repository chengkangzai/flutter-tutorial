class Transaction {
  int? id;
  int categoryId;
  String? categoryName;
  String transactionDate;
  int amount;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.id,
    required this.categoryId,
    required this.transactionDate,
    required this.amount,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'] ?? '',
      transactionDate: json['transaction_date'],
      amount: json['amount'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

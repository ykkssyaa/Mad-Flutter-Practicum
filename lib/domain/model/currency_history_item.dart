class CurrencyHistoryItem {
  const CurrencyHistoryItem({required this.date, required this.value});

  final DateTime date;
  final double value;

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'value': value,
      };

  static CurrencyHistoryItem fromMap(Map<String, dynamic> map) => CurrencyHistoryItem(
        date: DateTime.parse(map['date'] as String),
        value: (map['value'] as num).toDouble(),
      );
}


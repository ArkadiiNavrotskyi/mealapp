class ShoppingItem {
  final String id;           // unique (mealId + ingredient)
  final String mealId;
  final String mealTitle;
  final String text;         // ingredient line
  bool checked;
  final double quantity;     // base quantity (parsed from text if possible)
  final String unit;         // g, ml, pcs, ...

  ShoppingItem({
    required this.id,
    required this.mealId,
    required this.mealTitle,
    required this.text,
    this.checked = false,
    this.quantity = 1,
    this.unit = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'mealId': mealId,
    'mealTitle': mealTitle,
    'text': text,
    'checked': checked,
    'quantity': quantity,
    'unit': unit,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
    id: json['id'] as String,
    mealId: json['mealId'] as String,
    mealTitle: json['mealTitle'] as String,
    text: json['text'] as String,
    checked: json['checked'] as bool? ?? false,
    quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
    unit: json['unit'] as String? ?? '',
  );
}
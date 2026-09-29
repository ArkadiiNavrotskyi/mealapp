import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item.dart';

class ShoppingProvider extends ChangeNotifier {
  static const _key = 'shopping_items';
  final SharedPreferences prefs;

  final List<ShoppingItem> _items = [];

  ShoppingProvider(this.prefs) {
    _load();
  }

  List<ShoppingItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.length;
  int get checkedCount => _items.where((i) => i.checked).length;

  /// Add all ingredients of a meal. Skips duplicates by mealId+text.
  void addMealIngredients({
    required String mealId,
    required String mealTitle,
    required List<String> ingredients,
  }) {
    for (final raw in ingredients) {
      final parsed = _parseIngredient(raw);
      final id = '$mealId::${parsed.text}';
      final existingIndex = _items.indexWhere((i) => i.id == id);
      if (existingIndex != -1) continue;

      _items.add(
        ShoppingItem(
          id: id,
          mealId: mealId,
          mealTitle: mealTitle,
          text: parsed.text,
          quantity: parsed.quantity,
          unit: parsed.unit,
        ),
      );
    }
    _save();
    notifyListeners();
  }

  void toggle(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return;
    _items[i].checked = !_items[i].checked;
    _save();
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((e) => e.id == id);
    _save();
    notifyListeners();
  }

  void clearChecked() {
    _items.removeWhere((e) => e.checked);
    _save();
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _save();
    notifyListeners();
  }

  /// Group items by meal title — nice for the UI.
  Map<String, List<ShoppingItem>> get groupedByMeal {
    final Map<String, List<ShoppingItem>> map = {};
    for (final item in _items) {
      map.putIfAbsent(item.mealTitle, () => []).add(item);
    }
    return map;
  }

  // ---------- helpers ----------
  void _load() {
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final List<dynamic> list = jsonDecode(raw);
    _items
      ..clear()
      ..addAll(list.map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>)));
  }

  void _save() {
    final raw = jsonEncode(_items.map((e) => e.toJson()).toList());
    prefs.setString(_key, raw);
  }

  /// Very simple parser: extracts leading number + unit, rest is text.
  /// Examples:
  ///   "30g Pine Nuts" -> quantity 30, unit "g",  text "Pine Nuts"
  ///   "2 Eggs"        -> quantity 2,  unit "",   text "Eggs"
  ///   "Salt, Pepper"  -> quantity 1,  unit "",   text "Salt, Pepper"
  _ParsedIngredient _parseIngredient(String raw) {
    final regex = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*([a-zA-Zа-яА-Я]*)\s+(.+)$');
    final m = regex.firstMatch(raw);
    if (m != null) {
      return _ParsedIngredient(
        quantity: double.tryParse(m.group(1)!) ?? 1,
        unit: m.group(2) ?? '',
        text: m.group(3)!.trim(),
      );
    }
    // Handle forms like "300g Cherry Tomatoes" (no space between number and unit)
    final regex2 = RegExp(r'^\s*(\d+(?:\.\d+)?)([a-zA-Zа-яА-Я]+)\s+(.+)$');
    final m2 = regex2.firstMatch(raw);
    if (m2 != null) {
      return _ParsedIngredient(
        quantity: double.tryParse(m2.group(1)!) ?? 1,
        unit: m2.group(2) ?? '',
        text: m2.group(3)!.trim(),
      );
    }
    return _ParsedIngredient(quantity: 1, unit: '', text: raw.trim());
  }
}

class _ParsedIngredient {
  final double quantity;
  final String unit;
  final String text;
  _ParsedIngredient({
    required this.quantity,
    required this.unit,
    required this.text,
  });
}
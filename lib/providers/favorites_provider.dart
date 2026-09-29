import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'favorite_meal_ids';
  final SharedPreferences prefs;
  final Set<String> _ids = {};

  FavoritesProvider(this.prefs) {
    _load();
  }

  Set<String> get ids => _ids;

  bool isFavorite(String mealId) => _ids.contains(mealId);

  void toggle(String mealId) {
    if (_ids.contains(mealId)) {
      _ids.remove(mealId);
    } else {
      _ids.add(mealId);
    }
    prefs.setStringList(_key, _ids.toList());
    notifyListeners();
  }

  void _load() {
    final list = prefs.getStringList(_key);
    if (list != null) {
      _ids.addAll(list);
    }
  }
}
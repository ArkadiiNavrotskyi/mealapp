import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../models/filter_settings.dart';
import '../data/dummy_data.dart';

class MealsProvider extends ChangeNotifier {
  static const _customMealsKey = 'custom_meals';
  static const _customMapKey = 'custom_meals_map';

  FilterSettings _filters = const FilterSettings();
  final List<Meal> _customMeals = [];
  final Map<String, List<String>> _customByCategory = {};

  MealsProvider() {
    _loadCustom();
  }

  FilterSettings get filters => _filters;

  // ---------------- Public API ----------------

  /// All meals (dummy + custom) that match the current filters.
  List<Meal> get allMeals {
    final combined = [...dummyMeals, ..._customMeals];
    return combined.where(_passesFilters).toList();
  }

  /// Meals for a given category (dummy + custom) after filters.
  List<Meal> mealsForCategory(String categoryId) {
    final ids = <String>[
      ...?mealsByCategory[categoryId],
      ...?_customByCategory[categoryId],
    ];
    final all = [...dummyMeals, ..._customMeals];
    return all
        .where((m) => ids.contains(m.id) && _passesFilters(m))
        .toList();
  }

  /// Case-insensitive search by title.
  List<Meal> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return allMeals;
    return allMeals
        .where((m) => m.title.toLowerCase().contains(q))
        .toList();
  }

  Meal mealById(String id) {
    return [...dummyMeals, ..._customMeals]
        .firstWhere((m) => m.id == id);
  }

  /// Add a user-created meal to a category.
  void addCustomMeal(Meal meal, String categoryId) {
    _customMeals.add(meal);
    _customByCategory.putIfAbsent(categoryId, () => []).add(meal.id);
    _saveCustom();
    notifyListeners();
  }

  void removeCustomMeal(String id) {
    _customMeals.removeWhere((m) => m.id == id);
    for (final list in _customByCategory.values) {
      list.remove(id);
    }
    _saveCustom();
    notifyListeners();
  }

  // ---------------- Filters ----------------

  bool _passesFilters(Meal meal) {
    if (_filters.isGlutenFree && !meal.isGlutenFree) return false;
    if (_filters.isLactoseFree && !meal.isLactoseFree) return false;
    if (_filters.isVegetarian && !meal.isVegetarian) return false;
    if (_filters.isVegan && !meal.isVegan) return false;
    return true;
  }

  void setGlutenFree(bool v) {
    _filters = _filters.copyWith(isGlutenFree: v);
    notifyListeners();
  }

  void setLactoseFree(bool v) {
    _filters = _filters.copyWith(isLactoseFree: v);
    notifyListeners();
  }

  void setVegetarian(bool v) {
    _filters = _filters.copyWith(isVegetarian: v);
    notifyListeners();
  }

  void setVegan(bool v) {
    _filters = _filters.copyWith(isVegan: v);
    notifyListeners();
  }

  // ---------------- Persistence ----------------

  Future<void> _loadCustom() async {
    final prefs = await SharedPreferences.getInstance();
    final rawMeals = prefs.getString(_customMealsKey);
    final rawMap = prefs.getString(_customMapKey);

    if (rawMeals != null) {
      final List<dynamic> list = jsonDecode(rawMeals);
      _customMeals
        ..clear()
        ..addAll(list.map((e) => _mealFromJson(e as Map<String, dynamic>)));
    }
    if (rawMap != null) {
      final Map<String, dynamic> decoded =
      Map<String, dynamic>.from(jsonDecode(rawMap));
      _customByCategory.clear();
      decoded.forEach((k, v) {
        _customByCategory[k] =
        List<String>.from((v as List).map((e) => e.toString()));
      });
    }
    notifyListeners();
  }

  Future<void> _saveCustom() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _customMealsKey,
      jsonEncode(_customMeals.map(_mealToJson).toList()),
    );
    await prefs.setString(_customMapKey, jsonEncode(_customByCategory));
  }

  Map<String, dynamic> _mealToJson(Meal m) => {
    'id': m.id,
    'title': m.title,
    'imageUrl': m.imageUrl,
    'ingredients': m.ingredients,
    'steps': m.steps,
    'duration': m.duration,
    'complexity': m.complexity.index,
    'affordability': m.affordability.index,
    'isGlutenFree': m.isGlutenFree,
    'isLactoseFree': m.isLactoseFree,
    'isVegetarian': m.isVegetarian,
    'isVegan': m.isVegan,
    'rating': m.rating,
    'calories': m.calories,
    'protein': m.protein,
    'fat': m.fat,
    'carbs': m.carbs,
  };

  Meal _mealFromJson(Map<String, dynamic> j) => Meal(
    id: j['id'] as String,
    title: j['title'] as String,
    imageUrl: j['imageUrl'] as String,
    ingredients: List<String>.from(j['ingredients']),
    steps: List<String>.from(j['steps']),
    duration: j['duration'] as int,
    complexity: Complexity.values[j['complexity'] as int],
    affordability: Affordability.values[j['affordability'] as int],
    isGlutenFree: j['isGlutenFree'] as bool,
    isLactoseFree: j['isLactoseFree'] as bool,
    isVegetarian: j['isVegetarian'] as bool,
    isVegan: j['isVegan'] as bool,
    rating: (j['rating'] as num).toDouble(),
    calories: j['calories'] as int,
    protein: (j['protein'] as num).toDouble(),
    fat: (j['fat'] as num).toDouble(),
    carbs: (j['carbs'] as num).toDouble(),
  );
}
import 'package:flutter/material.dart';

enum Complexity { simple, challenging, hard }
enum Affordability { affordable, pricey, luxurious }

class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration; // minutes
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegetarian;
  final bool isVegan;
  final double rating; // 0..5
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  const Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegetarian,
    required this.isVegan,
    required this.rating,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  String get complexityLabel {
    switch (complexity) {
      case Complexity.simple:
        return 'Simple';
      case Complexity.challenging:
        return 'Challenging';
      case Complexity.hard:
        return 'Hard';
    }
  }

  String get affordabilityLabel {
    switch (affordability) {
      case Affordability.affordable:
        return 'Affordable';
      case Affordability.pricey:
        return 'Pricey';
      case Affordability.luxurious:
        return 'Luxurious';
    }
  }

  IconData get complexityIcon {
    switch (complexity) {
      case Complexity.simple:
        return Icons.sentiment_satisfied_alt;
      case Complexity.challenging:
        return Icons.trending_up;
      case Complexity.hard:
        return Icons.local_fire_department;
    }
  }

  IconData get affordabilityIcon {
    switch (affordability) {
      case Affordability.affordable:
        return Icons.attach_money;
      case Affordability.pricey:
        return Icons.attach_money;
      case Affordability.luxurious:
        return Icons.diamond;
    }
  }
}
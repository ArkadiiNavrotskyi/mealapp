import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../providers/meals_provider.dart';
import '../widgets/category_card.dart';
import '../utils/responsive.dart';
import 'meals_screen.dart';
import 'filters_screen.dart';
import 'search_screen.dart';
import 'meal_detail_screen.dart';
import 'add_custom_meal_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.categoryColumns(context);
    final filters = context.watch<MealsProvider>().filters;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Categories'),
        ),
        actions: [
          // 🎲 Random meal
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Surprise me!',
            onPressed: () => _openRandomMeal(context),
          ),
          // 🔍 Search
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search meals',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          // ➕ Add your own meal
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add your own meal',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const AddCustomMealScreen()),
              );
            },
          ),
          // 🎛 Filters
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Filters',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const FiltersScreen()),
                  );
                },
              ),
              if (filters.hasAny)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE85D04),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: Responsive.padding(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: dummyCategories.length,
        itemBuilder: (context, index) {
          final category = dummyCategories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MealsScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openRandomMeal(BuildContext context) {
    final provider = context.read<MealsProvider>();
    final meals = provider.allMeals;

    if (meals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No meals match the current filters.'),
        ),
      );
      return;
    }

    meals.shuffle();
    final meal = meals.first;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(meal: meal),
      ),
    );
  }
}
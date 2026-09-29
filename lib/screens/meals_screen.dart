import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/meals_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_state.dart';
import '../utils/responsive.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatelessWidget {
  final Category category;

  const MealsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final mealsProvider = context.watch<MealsProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final meals = mealsProvider.mealsForCategory(category.id);
    final columns = Responsive.mealColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(category.title),
        ),
      ),
      body: meals.isEmpty
          ? const EmptyState(
        icon: Icons.no_food,
        title: 'No meals found',
        message:
        'Try changing your filters or come back later.',
      )
          : GridView.builder(
        padding: Responsive.padding(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
        ),
        itemCount: meals.length,
        itemBuilder: (context, i) {
          final meal = meals[i];
          return MealCard(
            meal: meal,
            isFavorite: favoritesProvider.isFavorite(meal.id),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: meal),
                ),
              );
            },
            onFavoriteTap: () {
              favoritesProvider.toggle(meal.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(
                    favoritesProvider.isFavorite(meal.id)
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_state.dart';
import '../utils/responsive.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final mealsProvider = context.watch<MealsProvider>();
    final columns = Responsive.mealColumns(context);

    // Filter favorites by the current filters as well
    final meals = mealsProvider.allMeals
        .where((m) => favorites.isFavorite(m.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Your Favorites'),
        ),
      ),
      body: meals.isEmpty
          ? const EmptyState(
        icon: Icons.star_border,
        title: 'No favorites yet',
        message:
        'Tap the star on any meal to save it here for quick access.',
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
            isFavorite: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: meal),
                ),
              );
            },
            onFavoriteTap: () {
              favorites.toggle(meal.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Removed from favorites'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
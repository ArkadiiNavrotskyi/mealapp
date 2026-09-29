import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_state.dart';
import '../utils/responsive.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealsProvider = context.watch<MealsProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final results = mealsProvider.search(_query);
    final columns = Responsive.mealColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search meals...',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: results.isEmpty
          ? EmptyState(
        icon: Icons.search_off,
        title: 'No meals found',
        message: _query.isEmpty
            ? 'Start typing to search for meals.'
            : 'Try a different search term.',
      )
          : GridView.builder(
        padding: Responsive.padding(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
        ),
        itemCount: results.length,
        itemBuilder: (context, i) {
          final meal = results[i];
          return MealCard(
            meal: meal,
            isFavorite: favorites.isFavorite(meal.id),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: meal),
                ),
              );
            },
            onFavoriteTap: () => favorites.toggle(meal.id),
          );
        },
      ),
    );
  }
}
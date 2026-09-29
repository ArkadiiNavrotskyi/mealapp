import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../providers/shopping_provider.dart';
import '../utils/responsive.dart';
import '../utils/confetti_helper.dart';
import '../widgets/shimmer_image.dart';
import 'cooking_mode_screen.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  int _servings = 2;
  static const int _baseServings = 2;

  Meal get meal => widget.meal;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(meal.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meal.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'meal-image-${meal.id}',
                    child: ShimmerImage(
                      imageUrl: meal.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? const Color(0xFFE85D04) : Colors.white,
                ),
                onPressed: () {
                  if (!isFav) ConfettiHelper.pop(context);
                  favorites.toggle(meal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        favorites.isFavorite(meal.id)
                            ? 'Added to favorites'
                            : 'Removed from favorites',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: Responsive.padding(context, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final full = i < meal.rating.floor();
                        return Icon(
                          full ? Icons.star : Icons.star_border,
                          size: 20,
                          color: const Color(0xFFE85D04),
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        meal.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _infoChip(context, Icons.schedule,
                          '${meal.duration} min'),
                      _infoChip(context, meal.complexityIcon,
                          meal.complexityLabel),
                      _infoChip(context, meal.affordabilityIcon,
                          meal.affordabilityLabel),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add to shopping list
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE85D04),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<ShoppingProvider>()
                            .addMealIngredients(
                          mealId: meal.id,
                          mealTitle: meal.title,
                          ingredients: meal.ingredients,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('Added to shopping list'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        'Add to shopping list',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🍳 Start cooking mode
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xFFE85D04), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CookingModeScreen(meal: meal),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outline,
                          color: Color(0xFFE85D04)),
                      label: const Text(
                        'Start cooking mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE85D04),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nutrition
                  _sectionTitle(context, 'Nutrition per serving'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _nutritionBox(context, '${meal.calories}', 'kcal'),
                      const SizedBox(width: 10),
                      _nutritionBox(context, '${meal.protein}g', 'Protein'),
                      const SizedBox(width: 10),
                      _nutritionBox(context, '${meal.fat}g', 'Fat'),
                      const SizedBox(width: 10),
                      _nutritionBox(context, '${meal.carbs}g', 'Carbs'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Diet tags
                  _sectionTitle(context, 'Dietary'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (meal.isGlutenFree)
                        _dietTag(context, 'Gluten-free'),
                      if (meal.isLactoseFree)
                        _dietTag(context, 'Lactose-free'),
                      if (meal.isVegetarian) _dietTag(context, 'Vegetarian'),
                      if (meal.isVegan) _dietTag(context, 'Vegan'),
                      if (!meal.isGlutenFree &&
                          !meal.isLactoseFree &&
                          !meal.isVegetarian &&
                          !meal.isVegan)
                        _dietTag(context, 'No special diet'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ingredients with servings selector
                  Row(
                    children: [
                      Expanded(
                        child: _sectionTitle(context, 'Ingredients'),
                      ),
                      _ServingsSelector(
                        servings: _servings,
                        onChanged: (s) => setState(() => _servings = s),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...meal.ingredients.asMap().entries.map(
                        (e) => _bulletTile(context, e.value, e.key),
                  ),
                  const SizedBox(height: 24),

                  // Steps
                  _sectionTitle(context, 'Steps'),
                  const SizedBox(height: 10),
                  ...meal.steps.asMap().entries.map(
                        (e) => _stepTile(context, e.value, e.key + 1),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- helpers ----------

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: TextStyle(
      fontSize: Responsive.fontSize(context, baseSize: 20),
      fontWeight: FontWeight.bold,
      color: const Color(0xFFE85D04),
    ),
  );

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _nutritionBox(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFE85D04),
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dietTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE85D04).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE85D04),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _bulletTile(BuildContext context, String rawText, int index) {
    final scaledText = _scaleIngredient(rawText);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFE85D04),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              scaledText,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, baseSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _scaleIngredient(String raw) {
    if (_servings == _baseServings) return raw;
    final factor = _servings / _baseServings;
    final regex = RegExp(r'^\s*(\d+(?:\.\d+)?)(.*)$');
    final m = regex.firstMatch(raw);
    if (m == null) return raw;
    final value = double.tryParse(m.group(1)!) ?? 0;
    final scaled = value * factor;
    final formatted = scaled == scaled.roundToDouble()
        ? scaled.toStringAsFixed(0)
        : scaled.toStringAsFixed(1);
    return '$formatted${m.group(2)}';
  }

  Widget _stepTile(BuildContext context, String text, int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFE85D04).withOpacity(0.2),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Color(0xFFE85D04),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, baseSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Servings selector ----------------

class _ServingsSelector extends StatelessWidget {
  final int servings;
  final ValueChanged<int> onChanged;

  const _ServingsSelector({
    required this.servings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, () {
            if (servings > 1) onChanged(servings - 1);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people_alt_outlined,
                    size: 16, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  '$servings',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE85D04),
                  ),
                ),
              ],
            ),
          ),
          _btn(Icons.add, () => onChanged(servings + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
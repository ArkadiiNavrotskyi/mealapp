import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../utils/responsive.dart';
import '../utils/confetti_helper.dart';
import 'shimmer_image.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Responsive.radius(context, base: 20);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image fills the whole card
            Positioned.fill(
              child: Hero(
                tag: 'meal-image-${meal.id}',
                child: ShimmerImage(
                  imageUrl: meal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Dark gradient for text readability
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.35, 1.0],
                  ),
                ),
              ),
            ),

            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black.withOpacity(0.4),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: child,
                    ),
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      key: ValueKey(isFavorite),
                      color: isFavorite
                          ? const Color(0xFFE85D04)
                          : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    // 🎉 Confetti when adding to favorites
                    if (!isFavorite) {
                      ConfettiHelper.pop(context);
                    }
                    onFavoriteTap();
                  },
                ),
              ),
            ),

            // Title + chips
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    meal.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, baseSize: 16),
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(blurRadius: 6, color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _iconText(context, Icons.schedule,
                          '${meal.duration} min'),
                      _iconText(context, meal.complexityIcon,
                          meal.complexityLabel),
                      _iconText(context, meal.affordabilityIcon,
                          meal.affordabilityLabel),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconText(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            fontSize: Responsive.fontSize(context, baseSize: 12),
          ),
        ),
      ],
    );
  }
}
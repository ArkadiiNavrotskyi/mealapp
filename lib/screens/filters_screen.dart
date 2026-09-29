import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';
import '../widgets/filter_switch_tile.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealsProvider>();
    final f = provider.filters;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Your Filters'),
        ),
      ),
      body: ListView(
        children: [
          FilterSwitchTile(
            icon: Icons.grain,
            title: 'Gluten-free',
            subtitle: 'Only include gluten-free meals.',
            value: f.isGlutenFree,
            onChanged: provider.setGlutenFree,
          ),
          FilterSwitchTile(
            icon: Icons.local_drink,
            title: 'Lactose-free',
            subtitle: 'Only include lactose-free meals.',
            value: f.isLactoseFree,
            onChanged: provider.setLactoseFree,
          ),
          FilterSwitchTile(
            icon: Icons.eco,
            title: 'Vegetarian',
            subtitle: 'Only include vegetarian meals.',
            value: f.isVegetarian,
            onChanged: provider.setVegetarian,
          ),
          FilterSwitchTile(
            icon: Icons.spa,
            title: 'Vegan',
            subtitle: 'Only include vegan meals.',
            value: f.isVegan,
            onChanged: provider.setVegan,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Filters are applied to every category and to the favorites list.',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
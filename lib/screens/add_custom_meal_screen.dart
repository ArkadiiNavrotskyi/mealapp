import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meals_provider.dart';
import '../data/dummy_data.dart';
import '../utils/responsive.dart';

class AddCustomMealScreen extends StatefulWidget {
  const AddCustomMealScreen({super.key});

  @override
  State<AddCustomMealScreen> createState() => _AddCustomMealScreenState();
}

class _AddCustomMealScreenState extends State<AddCustomMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  String _categoryId = dummyCategories.first.id;
  int _duration = 30;
  Complexity _complexity = Complexity.simple;
  Affordability _affordability = Affordability.affordable;

  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _isVegetarian = false;
  bool _isVegan = false;

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final steps = _stepsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final meal = Meal(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800'
          : _imageController.text.trim(),
      ingredients: ingredients,
      steps: steps,
      duration: _duration,
      complexity: _complexity,
      affordability: _affordability,
      isGlutenFree: _isGlutenFree,
      isLactoseFree: _isLactoseFree,
      isVegetarian: _isVegetarian,
      isVegan: _isVegan,
      rating: 5.0,
      calories: 0,
      protein: 0,
      fat: 0,
      carbs: 0,
    );

    context.read<MealsProvider>().addCustomMeal(meal, _categoryId);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your meal was added!'),
        backgroundColor: Color(0xFF43A047),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your own meal'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: Responsive.padding(context),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Meal title',
                prefixIcon: Icon(Icons.restaurant),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().length < 2) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _categoryId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: dummyCategories
                  .map((c) => DropdownMenuItem(
                value: c.id,
                child: Text(c.title),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _categoryId = v!),
            ),
            const SizedBox(height: 12),

            // Duration
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.white70),
                const SizedBox(width: 12),
                const Text('Duration'),
                Expanded(
                  child: Slider(
                    value: _duration.toDouble(),
                    min: 5,
                    max: 180,
                    divisions: 35,
                    label: '$_duration min',
                    activeColor: const Color(0xFFE85D04),
                    onChanged: (v) =>
                        setState(() => _duration = v.round()),
                  ),
                ),
                Text('$_duration min',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            // Complexity
            DropdownButtonFormField<Complexity>(
              value: _complexity,
              decoration: const InputDecoration(
                labelText: 'Complexity',
                prefixIcon: Icon(Icons.trending_up),
                border: OutlineInputBorder(),
              ),
              items: Complexity.values
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c.name),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _complexity = v!),
            ),
            const SizedBox(height: 12),

            // Affordability
            DropdownButtonFormField<Affordability>(
              value: _affordability,
              decoration: const InputDecoration(
                labelText: 'Affordability',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              items: Affordability.values
                  .map((a) => DropdownMenuItem(
                value: a,
                child: Text(a.name),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _affordability = v!),
            ),
            const SizedBox(height: 20),

            const Text('Dietary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Gluten-free'),
                  selected: _isGlutenFree,
                  onSelected: (v) => setState(() => _isGlutenFree = v),
                ),
                FilterChip(
                  label: const Text('Lactose-free'),
                  selected: _isLactoseFree,
                  onSelected: (v) => setState(() => _isLactoseFree = v),
                ),
                FilterChip(
                  label: const Text('Vegetarian'),
                  selected: _isVegetarian,
                  onSelected: (v) => setState(() => _isVegetarian = v),
                ),
                FilterChip(
                  label: const Text('Vegan'),
                  selected: _isVegan,
                  onSelected: (v) => setState(() => _isVegan = v),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _ingredientsController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Ingredients (one per line)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.list_alt),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final lines = (v ?? '')
                    .split('\n')
                    .where((s) => s.trim().isNotEmpty)
                    .length;
                return lines == 0 ? 'Add at least one ingredient' : null;
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _stepsController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Steps (one per line)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.format_list_numbered),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final lines = (v ?? '')
                    .split('\n')
                    .where((s) => s.trim().isNotEmpty)
                    .length;
                return lines == 0 ? 'Add at least one step' : null;
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE85D04),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save meal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
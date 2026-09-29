import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import '../widgets/empty_state.dart';
import '../utils/responsive.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopping = context.watch<ShoppingProvider>();
    final grouped = shopping.groupedByMeal;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Shopping List'),
        ),
        actions: [
          if (shopping.items.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'clear_checked') {
                  shopping.clearChecked();
                } else if (value == 'clear_all') {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Clear all?'),
                      content: const Text(
                          'Remove every item from the shopping list?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            shopping.clearAll();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'clear_checked',
                  child: Text('Clear checked items'),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear all'),
                ),
              ],
            ),
        ],
      ),
      body: shopping.items.isEmpty
          ? const EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Your shopping list is empty',
        message:
        'Open any meal and tap "Add to shopping list" to build your list.',
      )
          : Column(
        children: [
          // Progress header
          Container(
            margin: Responsive.padding(context, vertical: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_basket,
                    color: Color(0xFFE85D04)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${shopping.checkedCount} of ${shopping.totalCount} items',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: shopping.totalCount == 0
                              ? 0
                              : shopping.checkedCount /
                              shopping.totalCount,
                          minHeight: 6,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFE85D04)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Grouped list
          Expanded(
            child: ListView(
              padding: Responsive.padding(context, vertical: 0),
              children: grouped.entries.map((entry) {
                return _MealGroup(
                  mealTitle: entry.key,
                  items: entry.value,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealGroup extends StatelessWidget {
  final String mealTitle;
  final List<dynamic> items;

  const _MealGroup({required this.mealTitle, required this.items});

  @override
  Widget build(BuildContext context) {
    final shopping = context.read<ShoppingProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu,
                      size: 16, color: Color(0xFFE85D04)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mealTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...items.map((item) {
              return CheckboxListTile(
                dense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFFE85D04),
                value: item.checked,
                onChanged: (_) => shopping.toggle(item.id),
                title: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(
                        context, baseSize: 14),
                    decoration: item.checked
                        ? TextDecoration.lineThrough
                        : null,
                    color: item.checked ? Colors.grey : null,
                  ),
                ),
                subtitle: item.quantity != 1 || item.unit.isNotEmpty
                    ? Text(
                  '${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1)} ${item.unit}'
                      .trim(),
                  style: const TextStyle(fontSize: 11),
                )
                    : null,
                secondary: IconButton(
                  icon: const Icon(Icons.close,
                      size: 18, color: Colors.white38),
                  onPressed: () => shopping.remove(item.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
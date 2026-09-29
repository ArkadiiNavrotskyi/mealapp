import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'shopping_list_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  static const _pages = [
    CategoriesScreen(),
    FavoritesScreen(),
    ShoppingListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final shopping = context.watch<ShoppingProvider>();
    final remaining =
        shopping.totalCount - shopping.checkedCount;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: remaining > 0,
              label: Text('$remaining'),
              backgroundColor: const Color(0xFFE85D04),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: remaining > 0,
              label: Text('$remaining'),
              backgroundColor: const Color(0xFFE85D04),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Shopping',
          ),
        ],
      ),
    );
  }
}
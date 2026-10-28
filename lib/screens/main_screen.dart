import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/favorites_service.dart';
import 'add_recipe_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;
  List<Recipe> _favorites = [];
  bool _favoritesLoading = true;

  final FavoritesService _favoritesService = FavoritesService();

  Set<int> get _favoriteIds =>
      _favorites.map((recipe) => recipe.id).toSet();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final recipes = await _favoritesService.loadFavorites();

      if (!mounted) return;

      setState(() {
        _favorites = recipes;
        _favoritesLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _favoritesLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    final updated = List<Recipe>.from(_favorites);

    if (updated.any((item) => item.id == recipe.id)) {
      updated.removeWhere((item) => item.id == recipe.id);
    } else {
      updated.insert(0, recipe);
    }

    setState(() {
      _favorites = updated;
    });

    try {
      await _favoritesService.saveFavorites(updated);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save favourites locally.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const titles = [
      'RecipeBox',
      'My Favourites',
      'Add a Recipe',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedTab],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          HomeScreen(
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
          ),
          FavoritesScreen(
            recipes: _favorites,
            loading: _favoritesLoading,
            favoriteIds: _favoriteIds,
            onToggleFavorite: _toggleFavorite,
          ),
          AddRecipeScreen(
            onAdded: () {
              setState(() {
                _selectedTab = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Recipe',
          ),
        ],
      ),
    );
  }
}
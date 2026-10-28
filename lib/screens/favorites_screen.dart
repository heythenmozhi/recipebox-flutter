import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final bool loading;
  final Set<int> favoriteIds;
  final Future<void> Function(Recipe) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.recipes,
    required this.loading,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (recipes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 56),
              SizedBox(height: 12),
              Text('No favourites yet'),
              SizedBox(height: 4),
              Text(
                'Tap the heart on a recipe to save it here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        return RecipeCard(
          recipe: recipe,
          isFavorite: favoriteIds.contains(recipe.id),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(
                  recipeId: recipe.id,
                  favoriteIds: favoriteIds,
                  onToggleFavorite: onToggleFavorite,
                ),
              ),
            );
          },
          onFavoriteTap: () {
            onToggleFavorite(recipe);
          },
        );
      },
    );
  }
}
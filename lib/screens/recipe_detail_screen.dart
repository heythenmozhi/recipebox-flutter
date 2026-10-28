import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_api.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final Set<int> favoriteIds;
  final Future<void> Function(Recipe) onToggleFavorite;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  State<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState
    extends State<RecipeDetailScreen> {
  late Future<Recipe> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = RecipeApi.getRecipe(widget.recipeId);
  }

  void _retry() {
    setState(() {
      _recipeFuture = RecipeApi.getRecipe(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load recipe details.',
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final recipe = snapshot.data;

          if (recipe == null) {
            return const Center(
              child: Text('Recipe details are unavailable.'),
            );
          }

          return _buildDetails(recipe);
        },
      ),
    );
  }

  Widget _buildDetails(Recipe recipe) {
    final isFavorite = widget.favoriteIds.contains(recipe.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: recipe.image.isEmpty
                ? const ColoredBox(
                    color: Color(0xFFFFE0B2),
                    child: Icon(Icons.restaurant, size: 64),
                  )
                : Image.network(
                    recipe.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const ColoredBox(
                        color: Color(0xFFFFE0B2),
                        child: Icon(Icons.restaurant, size: 64),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                recipe.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              tooltip: isFavorite
                  ? 'Remove favourite'
                  : 'Add favourite',
              onPressed: () {
                widget.onToggleFavorite(recipe);
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
          ],
        ),
        Text('${recipe.cuisine} • ${recipe.difficulty}'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              label: 'Prep',
              value: '${recipe.prepTime} min',
            ),
            _InfoChip(
              label: 'Cook',
              value: '${recipe.cookTime} min',
            ),
            _InfoChip(
              label: 'Servings',
              value: '${recipe.servings}',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (recipe.ingredients.isEmpty)
          const Text('No ingredients listed for this recipe.')
        else
          ...recipe.ingredients.map(
            (ingredient) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(ingredient),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Instructions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (recipe.instructions.isEmpty)
          const Text('No instructions listed for this recipe.')
        else
          ...recipe.instructions.asMap().entries.map(
            (entry) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Text('${entry.key + 1}'),
              ),
              title: Text(entry.value),
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
    );
  }
}
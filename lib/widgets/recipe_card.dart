import 'package:flutter/material.dart';

import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: recipe.image.isEmpty
                      ? const ColoredBox(
                          color: Color(0xFFFFE0B2),
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 56,
                            ),
                          ),
                        )
                      : Image.network(
                          recipe.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return const ColoredBox(
                              color: Color(0xFFFFE0B2),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 56,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Remove from favourites'
                          : 'Add to favourites',
                      onPressed: onFavoriteTap,
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${recipe.cuisine} • ${recipe.prepTime} min prep',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
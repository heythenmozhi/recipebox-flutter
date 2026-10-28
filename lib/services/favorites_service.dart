import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

class FavoritesService {
  static const String _storageKey = 'recipebox_favorites';

  Future<List<Recipe>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);

    if (stored == null || stored.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(stored);

    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map>()
        .map(
          (item) => Recipe.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveFavorites(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _storageKey,
      jsonEncode(
        recipes.map((recipe) => recipe.toJson()).toList(),
      ),
    );
  }
}
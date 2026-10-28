import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';

class RecipeApi {
  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 20);

  // Fetch recipes, with optional search and pagination.
  static Future<Map<String, dynamic>> getRecipes({
    String query = '',
    int skip = 0,
    int limit = 20,
  }) async {
    final trimmedQuery = query.trim();

    final endpoint =
        trimmedQuery.isEmpty ? 'recipes' : 'recipes/search';

    final uri = Uri.parse('$_baseUrl/$endpoint').replace(
      queryParameters: {
        if (trimmedQuery.isNotEmpty) 'q': trimmedQuery,
        'limit': '$limit',
        'skip': '$skip',
      },
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Could not load recipes (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected recipes response.');
    }

    return decoded;
  }

  // Fetch one recipe using its ID.
  static Future<Recipe> getRecipe(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/recipes/$id'))
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Could not load this recipe (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected recipe response.');
    }

    return Recipe.fromJson(decoded);
  }

  // Submit a new recipe.
  static Future<Map<String, dynamic>> addRecipe({
    required String name,
    required String cuisine,
    required int prepTime,
    required List<String> ingredients,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/recipes/add'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': name.trim(),
            'cuisine': cuisine.trim(),
            'prepTimeMinutes': prepTime,
            'cookTimeMinutes': 0,
            'ingredients': ingredients,
            'instructions': <String>[],
          }),
        )
        .timeout(_timeout);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Could not add recipe (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Unexpected add-recipe response.',
      );
    }

    return decoded;
  }
}
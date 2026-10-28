class Recipe {
  final int id;
  final String name;
  final String cuisine;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;

  const Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Untitled recipe',
      cuisine: json['cuisine']?.toString() ?? 'Other',
      image: json['image']?.toString() ?? '',
      ingredients: (json['ingredients'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
      instructions: (json['instructions'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
      prepTime: (json['prepTimeMinutes'] as num?)?.toInt() ?? 0,
      cookTime: (json['cookTimeMinutes'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      difficulty: json['difficulty']?.toString() ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'image': image,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTimeMinutes': prepTime,
      'cookTimeMinutes': cookTime,
      'servings': servings,
      'difficulty': difficulty,
    };
  }
}
import 'package:flutter/material.dart';

import '../services/recipe_api.dart';

class AddRecipeScreen extends StatefulWidget {
  final VoidCallback onAdded;

  const AddRecipeScreen({
    super.key,
    required this.onAdded,
  });

  @override
  State<AddRecipeScreen> createState() =>
      _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _prepController = TextEditingController();
  final _ingredientsController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _prepController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredients = _ingredientsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    setState(() {
      _submitting = true;
    });

    try {
      final response = await RecipeApi.addRecipe(
        name: _nameController.text.trim(),
        cuisine: _cuisineController.text.trim(),
        prepTime: int.parse(_prepController.text.trim()),
        ingredients: ingredients,
      );

      if (!mounted) return;

      final id = response['id'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recipe submitted successfully'
            '${id == null ? '' : ' (ID: $id)'}. '
            'DummyJSON simulates this POST; '
            'it does not permanently save the recipe.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _cuisineController.clear();
      _prepController.clear();
      _ingredientsController.clear();

      widget.onAdded();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not submit recipe: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create a recipe',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Enter the recipe details below.'),
            const SizedBox(height: 20),

            // Recipe name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Recipe name',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                return _requiredText(value, 'Recipe name');
              },
            ),
            const SizedBox(height: 14),

            // Cuisine
            TextFormField(
              controller: _cuisineController,
              decoration: const InputDecoration(
                labelText: 'Cuisine',
                prefixIcon: Icon(Icons.public),
              ),
              validator: (value) {
                return _requiredText(value, 'Cuisine');
              },
            ),
            const SizedBox(height: 14),

            // Preparation time
            TextFormField(
              controller: _prepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preparation time (minutes)',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Preparation time is required.';
                }

                final minutes = int.tryParse(value.trim());

                if (minutes == null || minutes < 0) {
                  return 'Enter a valid non-negative number.';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),

            // Ingredients
            TextFormField(
              controller: _ingredientsController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                hintText: 'Rice, tomato, onion, salt',
                helperText:
                    'Separate each ingredient with a comma.',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.checklist),
              ),
              validator: (value) {
                final items = (value ?? '')
                    .split(',')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty);

                if (items.isEmpty) {
                  return 'Enter at least one ingredient.';
                }

                return null;
              },
            ),
            const SizedBox(height: 22),

            // Submit button
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.add),
              label: Text(
                _submitting ? 'Submitting...' : 'Add recipe',
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Add your recipe to enjoyy ',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
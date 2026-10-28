import 'dart:async';

import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_api.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Set<int> favoriteIds;
  final Future<void> Function(Recipe) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  List<Recipe> _recipes = [];
  int _total = 0;
  int _skip = 0;

  static const int _limit = 20;

  bool _loading = true;
  bool _loadingMore = false;

  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 250 &&
        !_loading &&
        !_loadingMore &&
        _recipes.length < _total) {
      _fetchRecipes(nextPage: true);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () {
        if (!mounted) return;

        setState(() {
          _query = value.trim();
        });

        _fetchRecipes();
      },
    );
  }

  Future<void> _fetchRecipes({bool nextPage = false}) async {
    if (_loadingMore ||
        (nextPage && _recipes.length >= _total)) {
      return;
    }

    setState(() {
      _error = null;

      if (nextPage) {
        _loadingMore = true;
      } else {
        _loading = true;
        _skip = 0;
      }
    });

    try {
      final result = await RecipeApi.getRecipes(
        query: _query,
        skip: nextPage ? _skip : 0,
        limit: _limit,
      );

      final fetched = (result['recipes'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => Recipe.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _total = (result['total'] as num?)?.toInt() ??
            fetched.length;

        if (nextPage) {
          _recipes = [..._recipes, ...fetched];
          _skip += fetched.length;
        } else {
          _recipes = fetched;
          _skip = fetched.length;
        }

        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  void _openRecipe(Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(
          recipeId: recipe.id,
          favoriteIds: widget.favoriteIds,
          onToggleFavorite: widget.onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _query = '';
                        });

                        _fetchRecipes();
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 10),
              const Text('Could not load recipes'),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _fetchRecipes,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_food, size: 48),
            const SizedBox(height: 8),
            Text(
              _query.isEmpty
                  ? 'No recipes available'
                  : 'No recipes found',
            ),
            FilledButton(
              onPressed: _fetchRecipes,
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchRecipes,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _recipes.length + (_loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _recipes.length) {
            return const Padding(
              padding: EdgeInsets.all(18),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final recipe = _recipes[index];

          return RecipeCard(
            recipe: recipe,
            isFavorite: widget.favoriteIds.contains(recipe.id),
            onTap: () => _openRecipe(recipe),
            onFavoriteTap: () {
              widget.onToggleFavorite(recipe);
            },
          );
        },
      ),
    );
  }
}
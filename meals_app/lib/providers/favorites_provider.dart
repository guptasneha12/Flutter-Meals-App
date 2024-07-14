// this provider stores all the list of favorites meals

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);
// to add or remove items in favorite
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal); // look into the existing list
    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal]; // new list
    }
  }
}

final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier,List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});

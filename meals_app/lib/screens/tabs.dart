// it loads other screens or embeded screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/fliters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/providers/favorites_provider.dart';

const kinitialFilters={
  Filter.glutenFree:false,   // false means filter is not enabled
  Filter.lactoseFree:false,
  Filter.vegetarian:false,
  Filter.vegan:false,
};


// this is stateful widget because we have to update the screen  on changing from tab a to tab b
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

// storing the selected filter
Map<Filter,bool> _selectedFilters=kinitialFilters ;


// message display when we add items as fav
  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

// to check if meal is already is in favorite list or not
  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);
  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorite.');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //       _showInfoMessage('Marked as a favorite');
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier)async {
    if (identifier == 'filters') {
      Navigator.of(context).pop();
    final result= await Navigator.of(context).push<Map<Filter,bool>>(MaterialPageRoute(
        builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters,),
      ),
      );


      setState(() {
        _selectedFilters=result ?? kinitialFilters ;     
      });
    } 
    else {
      Navigator.of(context)
          .pop(); // closing the drawer if we click on the meal screen after clicking it close the drawer
   

    }
  }

  @override
  Widget build(context) {
  final meals=ref.watch(mealsProvider);     // it watch as well as returns the data it watches
final availableMeals=meals.where((meal){
  if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
    return false;
  }
   if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
    return false;
  }
   if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
    return false;
  }
   if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
    return false;
  }
return true;

}).toList();

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals:availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals=ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = ' Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      // for creating side drawer
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex, // this will highlight our current tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

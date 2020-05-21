import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/logger.dart';

String selectedCategorie = "All";

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchControl = new TextEditingController();
  bool isDirty = false;

  List<Recipe> filterRecipes() {
    String text = _searchControl.text;
    List<Recipe> suggestedRecipesList =
        Provider.of<RecipeProvider>(context).suggestedRecipes;
    if (text == "") return suggestedRecipesList;
    List<Recipe> filtered = suggestedRecipesList
        .where(
            (recipe) => recipe.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    return filtered;
  }

  Widget buildMyBreads(List<Recipe> recipes) {
    if (recipes.length == 0) {
      return Container(
        height: 50,
        child: Text('No matches'),
      );
    }
    return Container(
      height: 250,
      child: ListView.builder(
          itemCount: recipes.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SpecialistTile(
                name: recipes[index].name,
                imgAssetPath:
                    'https://www.homemadefoodjunkie.com/wp-content/uploads/2017/11/IMG_1354-735x490.jpg',
                backColor: Colors.amber.withOpacity(0.2 * (index + 1)),
                onClick: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Recipe changed to ${recipes[index].name}')));
                  Provider.of<RecipeProvider>(context, listen: false)
                      .changeCurrentRecipe(recipes[index]);
                });
          }),
    );
  }

  Widget buildFeatured(List<Recipe> recipes) {
    if (recipes.length == 0) {
      return Container(
        height: 50,
        child: Text('No matches'),
      );
    }
    return Container(
      height: 250,
      child: ListView.builder(
          itemCount: recipes.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SpecialistTile(
              name: recipes[index].name,
              imgAssetPath:
                  'https://www.homemadefoodjunkie.com/wp-content/uploads/2017/11/IMG_1354-735x490.jpg',
              backColor: Colors.deepPurple.withOpacity(0.2 * (index + 1)),
              onClick: () {},
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    I18n i18n = I18n.of(context);
    List<Recipe> suggestedRecipes = filterRecipes();

    if (isDirty) {
      setState(() {
        isDirty = false;
      });
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              i18n.translate('home_screen_find_recipe'),
              style: TextStyle(
                  color: Colors.black87.withOpacity(0.8),
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: i18n.translate('home_screen_search'),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _searchControl,
                  onChanged: (text) {
                    setState(() {
                      isDirty = true;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              i18n.translate('home_screen_my_breads'),
              style: TextStyle(
                  color: Colors.black87.withOpacity(0.8),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            buildMyBreads(suggestedRecipes),
            SizedBox(
              height: 20,
            ),
            Text(
              i18n.translate('home_screen_featured'),
              style: TextStyle(
                  color: Colors.black87.withOpacity(0.8),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            buildFeatured(suggestedRecipes),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialistTile extends StatefulWidget {
  final String name;
  final String imgAssetPath;
  final Color backColor;
  final Function onClick;
  SpecialistTile(
      {@required this.name,
      @required this.imgAssetPath,
      @required this.backColor,
      @required this.onClick});

  @override
  _SpecialistTileState createState() => _SpecialistTileState();
}

class _SpecialistTileState extends State<SpecialistTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            color: widget.backColor, borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 6,
            ),
            Image.network(
              widget.imgAssetPath,
              height: 160,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}

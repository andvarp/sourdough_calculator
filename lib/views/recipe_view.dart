import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RecipeView extends StatefulWidget {
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool isEditMode = true;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    Recipe recipe = recipeProvider.currentRecipe;
    double width = MediaQuery.of(context).size.width;

    return VisibilityDetector(
      key: Key('RECIPE_VIEW'),
      onVisibilityChanged: (VisibilityInfo info) {
        setState(() {
          isVisible = info.visibleFraction != 0.0 ? true : false;
//          logger.d(isVisible);
        });
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: width * 0.5,
                    child: Text(
                      recipe.name,
                      style: TextStyle(
                          color: Colors.black87.withOpacity(0.8),
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  isEditMode
                      ? IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                        ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          color: Colors.black87.withOpacity(0.8),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: IngredientBarListView(
                          ingredients: recipe.ingredients,
                          isEditMode: isEditMode,
                          triggerAnimation: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                onPressed: () {
                  recipeProvider.safeToLocalStorage();
                },
                child: const Text('Save to the phone',
                    style: TextStyle(fontSize: 20)),
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                child: Text(
                  recipe.prettyPrint(),
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientBarListView extends StatelessWidget {
  IngredientBarListView({
    @required this.ingredients,
    @required this.isEditMode,
    this.isSubIngredient = false,
    this.triggerAnimation,
  }) : assert(ingredients != null);

  final List<Ingredient> ingredients;
  final bool isSubIngredient;
  final bool isEditMode;
  final bool triggerAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder: (BuildContext context, int index) => IngredientBar(
          ingredient: ingredients[index],
          isSubIngredient: isSubIngredient,
          isEditMode: isEditMode,
          triggerAnimation: triggerAnimation,
        ),
      ),
    );
  }
}

class IngredientBar extends StatefulWidget {
  final Ingredient ingredient;
  final bool isSubIngredient;
  final bool isEditMode;
  final bool triggerAnimation;

  IngredientBar({
    @required this.ingredient,
    @required this.isSubIngredient,
    @required this.isEditMode,
    @required this.triggerAnimation,
  }) : assert(ingredient != null);

  @override
  _IngredientBarState createState() => _IngredientBarState();
}

class _IngredientBarState extends State<IngredientBar> {
  double value;

  @override
  Widget build(BuildContext context) {
    bool showAnimationContainer = !widget.isEditMode ||
        widget.isEditMode && widget.ingredient.valueBounds == null;
    bool showSlider =
        widget.isEditMode && widget.ingredient.valueBounds != null;
    bool showDivider = !widget.isSubIngredient;

//    bool showAnimationContainer = true;
//    bool showSlider = true;

    if (value == null) {
      value = widget.ingredient.percent * 100;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.ingredient.name, // TODO: this needs translation
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              Text(
                printPercent(value / 100),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          showAnimationContainer ? SizedBox(height: 10.0) : Container(),
          showAnimationContainer
              ? Padding(
                  padding: EdgeInsets.fromLTRB(46, 34, 46, 14),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 0.9],
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 100),
                      duration: Duration(seconds: 1, milliseconds: 500),
                      builder:
                          (BuildContext context, double size, Widget child) {
                        return FractionallySizedBox(
                          widthFactor: widget.ingredient.percent * (size / 100),
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      child: FractionallySizedBox(),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20.0,
          ),
          showSlider
              ? Row(
                  children: <Widget>[
                    Text(
                      printPercent(
                          (widget?.ingredient?.valueBounds?.elementAt(0) ?? 0) /
                              100),
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.deepOrangeAccent,
                            inactiveTrackColor: Colors.black.withOpacity(0.1),
                            trackShape: RoundedRectSliderTrackShape(),
                            thumbColor: Colors.deepOrange,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 15.0),
                            overlayColor: Colors.grey.withAlpha(32),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 28.0),
                            trackHeight: 8.0,
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.deepOrangeAccent,
                            inactiveTickMarkColor: Colors.black.withOpacity(0),
                            valueIndicatorShape:
                                PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.deepOrangeAccent,
                            valueIndicatorTextStyle:
                                TextStyle(color: Colors.white),
                          ),
                          child: Slider(
                            onChanged: (value) {
                              setState(() {
                                this.value = value;
                                logger.d(value);
                              });
                            },
                            value: value,
                            label: '$value',
                            min:
                                widget?.ingredient?.valueBounds?.elementAt(0) ??
                                    0,
                            max:
                                widget?.ingredient?.valueBounds?.elementAt(1) ??
                                    100,
//                    divisions: (widget?.ingredient?.valueBounds[1] - widget?.ingredient?.valueBounds[0]).toInt(),
//                    divisions: 10,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      printPercent(
                          (widget?.ingredient?.valueBounds?.elementAt(1) ??
                                  100) /
                              100),
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                  ],
                )
              : Container(),
          showSlider ? SizedBox(height: 10.0) : Container(),
          buildSubIngredients(subIngredients: widget.ingredient.subIngredients),
          showDivider ? Divider() : Container(),
        ],
      ),
    );
  }

  Widget buildSubIngredients({List<Ingredient> subIngredients}) {
    if (subIngredients != null && subIngredients.length > 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: IngredientBarListView(
          ingredients: subIngredients,
          isSubIngredient: true,
          isEditMode: widget.isEditMode,
          triggerAnimation: widget.triggerAnimation,
        ),
      );
    }
    return Container();
  }
}

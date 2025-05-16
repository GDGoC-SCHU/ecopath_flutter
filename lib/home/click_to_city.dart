import 'package:eco_path/data/string.dart';
import 'package:eco_path/recommend/map_page.dart';
import 'package:eco_path/recommend/recommend.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void clickToCity(BuildContext context, String cityName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecommendPage(city: cityName),
    ),
  );
}

void clickToMap(BuildContext context, List<Map<String, String>> list) {
  List<String> selectedCategory = [];
  List<String> placeNames = [];

  for (var i in list) {
    if (i.containsKey("category")) {
      selectedCategory.add(i["category"]!);
    }
    if (i.containsKey("name")) {
      placeNames.add(i["name"]!);
    }
  }

  Map<String, List<String>> placesList = {
    SELECTEDCATE: selectedCategory,
    PLACENAMES: placeNames
  };

  logger.f(placesList);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowMapPage(placesList: placesList)));
}

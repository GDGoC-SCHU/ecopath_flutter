import 'package:eco_path/recommand/recommand.dart';
import 'package:flutter/material.dart';

void clickToCity(BuildContext context, String cityName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecommandPage(city: cityName),
    ),
  );
}

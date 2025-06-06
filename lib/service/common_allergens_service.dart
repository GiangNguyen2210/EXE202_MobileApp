import 'package:exe202_mobile_app/models/DTOs/ingredient_reponse.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/allergies_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AllergensService {
  IconData _getIconForIngredient(String? iconName) {
    switch (iconName) {
      case "nut":
        return FontAwesomeIcons.seedling;
      case "leaf-outline":
        return Ionicons.leaf_outline;
      case "egg":
        return Icons.egg;
      case "shrimp":
        return Remix.file_shred_fill;
      case "milk":
        return Remix.cup_line;
      case "wheat":
        return Remix.leaf_line;
      case "fish":
        return Remix.restaurant_fill;
      default:
        return Icons.help_outline;
    }
  }

  AllergenItem mapIngredientToAllergen(IngredientResponse dto) {
    final String ingredientName = dto.ingredientName ?? 'Unknown name';
    final icon = _getIconForIngredient(dto.ingredientName);
    final int id = dto.ingredientId ?? 0;

    return AllergenItem(ingredientName, icon, id);
  }

  List<AllergenItem> parseIngredientToAllergenList(
    List<IngredientResponse> dtoList,
  ) {
    return dtoList.map((dto) => mapIngredientToAllergen(dto)).toList();
  }
}

import 'package:flutter/material.dart';

Color getColorFromString(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'pink':
      return Colors.pink;
    case 'brown':
      return Colors.brown;
    case 'grey':
    case 'gray':
      return Colors.grey;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'silver':
      return Color(0xFFC0C0C0);
    case 'gold':
      return Color(0xFFFFD700);
    default:
      // Try to parse as hex color code
      try {
        return Color(int.parse(colorName.replaceAll('#', '0xFF')));
      } catch (e) {
        // Default to grey if color is not recognized
        return Colors.grey;
      }
  }
}

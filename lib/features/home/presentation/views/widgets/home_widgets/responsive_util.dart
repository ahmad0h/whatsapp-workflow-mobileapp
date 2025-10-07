import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Helper method to get responsive padding
  static double getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 80;
    } else if (screenWidth > 900) {
      return 60;
    } else {
      return 48;
    }
  }

  /// Helper method to get responsive font sizes
  static double getHeaderFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 36;
    } else if (screenWidth > 900) {
      return 34;
    } else {
      return 32;
    }
  }

  /// Helper method to get responsive aspect ratio
  static double getGridAspectRatio(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;

    if (orientation == Orientation.landscape) {
      // Landscape mode - wider cards
      if (screenWidth >= 1400) {
        return 2.8; // Extra large tablets (iPad Pro 12.9" landscape)
      } else if (screenWidth >= 1200) {
        return 2.2; // Large tablets (iPad Pro 11" landscape)
      } else if (screenWidth >= 1024) {
        return 2.2; // Standard tablets (iPad 10.2" landscape)
      } else if (screenWidth >= 800) {
        return 1.9; // Medium tablets landscape
      } else {
        return 3; // Small tablets landscape
      }
    } else {
      // Portrait mode - taller cards
      if (screenWidth >= 1024) {
        return 1.5; // Large tablets portrait (iPad Pro 12.9")
      } else if (screenWidth >= 900) {
        return 1; // Standard large tablets portrait
      } else if (screenWidth >= 768) {
        return 1.2; // Medium tablets portrait (iPad Mini, standard iPad) - REDUCED from 3.5
      } else if (screenWidth >= 600) {
        return 1.3; // Smaller tablets portrait
      } else {
        return 1.5; // Very small tablets/large phones
      }
    }
  }

  static bool isLargeTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 1200;
  }
}

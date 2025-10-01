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
      if (screenWidth > 1200) {
        return 2.6; // More reasonable width-to-height ratio for large tablets
      } else {
        return 1.6; // Slightly taller for medium tablets in landscape
      }
    } else {
      if (screenWidth > 900) {
        return 1.4; // Good proportion for large tablets in portrait
      } else {
        return 1.7; // Taller cards for smaller tablets to accommodate content
      }
    }
  }

  static bool isLargeTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 1200;
  }
}

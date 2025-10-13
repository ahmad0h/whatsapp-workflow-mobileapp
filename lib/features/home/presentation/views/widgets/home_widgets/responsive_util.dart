// import 'package:flutter/material.dart';

// class ResponsiveUtils {
//   /// Helper method to get responsive padding
//   static double getHorizontalPadding(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth > 1200) {
//       return 80;
//     } else if (screenWidth > 900) {
//       return 60;
//     } else {
//       return 48;
//     }
//   }

//   /// Helper method to get responsive font sizes
//   static double getHeaderFontSize(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth > 1200) {
//       return 36;
//     } else if (screenWidth > 900) {
//       return 34;
//     } else {
//       return 32;
//     }
//   }

//   /// Helper method to get responsive aspect ratio
//   static double getGridAspectRatio(BuildContext context) {
//     final orientation = MediaQuery.of(context).orientation;
//     final screenWidth = MediaQuery.of(context).size.width;

//     if (orientation == Orientation.landscape) {
//       // Landscape mode (1340 x 800)
//       if (screenWidth >= 1200) {
//         return 2.2;
//       } else if (screenWidth >= 1024) {
//         return 2.0;
//       } else {
//         return 1.8;
//       }
//     } else {
//       // Portrait mode (800 x 1340)
//       if (screenWidth >= 900) {
//         return 1.3;
//       } else if (screenWidth >= 768) {
//         return 3; // Makes cards WIDER/SHORTER for 800px width
//       } else if (screenWidth >= 600) {
//         return 1.2;
//       } else {
//         return 1.3; // Phones
//       }
//     }
//   }

//   static bool isLargeTablet(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return screenWidth > 1200;
//   }
// }

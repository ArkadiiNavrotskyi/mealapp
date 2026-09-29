import 'package:flutter/material.dart';

class Responsive {
  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isCompact(BuildContext context) =>
      isSmallPhone(context) ||
          (isLandscape(context) && isMobile(context));

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static EdgeInsets padding(
      BuildContext context, {
        double horizontal = 16,
        double vertical = 16,
      }) {
    final width = screenWidth(context);
    final landscape = isLandscape(context);
    double h = horizontal;
    double v = vertical;

    if (width < 360) {
      h *= 0.6;
      v *= 0.6;
    } else if (width < 600) {
      h *= 0.8;
      v *= 0.8;
    } else if (width < 1200) {
      h *= 1.2;
      v *= 1.2;
    } else {
      h *= 1.5;
      v *= 1.5;
    }

    if (landscape) v *= 0.6;

    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  static double fontSize(BuildContext context, {double baseSize = 16}) {
    final width = screenWidth(context);
    final landscape = isLandscape(context);

    double scale;
    if (width < 360) {
      scale = 0.85;
    } else if (width < 600) {
      scale = 0.95;
    } else if (width < 1200) {
      scale = 1.1;
    } else {
      scale = 1.3;
    }

    if (landscape && isMobile(context)) scale *= 0.9;
    return baseSize * scale;
  }

  static double radius(BuildContext context, {double base = 16}) {
    return isCompact(context) ? base * 0.75 : base;
  }

  static double iconSize(BuildContext context, {double base = 24}) {
    final width = screenWidth(context);
    if (width < 360) return base * 0.8;
    if (width < 600) return base * 0.95;
    if (width < 1200) return base * 1.1;
    return base * 1.25;
  }

  // Number of grid columns for the Categories screen
  static int categoryColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width < 400) return 2;
    if (width < 900) return 2;
    if (width < 1400) return 3;
    return 4;
  }

  // Number of grid columns for the Meals/Favorites list
  static int mealColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width < 600) return 1;
    if (width < 1200) return 2;
    return 3;
  }
}
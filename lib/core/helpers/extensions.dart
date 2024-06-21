import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  void pop() {
    navigator.pop();
  }

  Future<dynamic> pushNamed(String routName, {Object? arguments}) {
    return navigator.pushNamed(routName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routName, {Object? arguments, required RoutePredicate predicate}) {
    return navigator.pushNamedAndRemoveUntil(routName, predicate, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routName, {Object? arguments}) {
    return navigator.pushReplacementNamed(routName, arguments: arguments);
  }
}

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension ThemeExtension on BuildContext {
  ThemeData get myTheme => Theme.of(this);
}

extension StringExtension on String {
  String capitalized() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

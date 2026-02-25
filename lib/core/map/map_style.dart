import 'dart:ui';

enum AppMapStyle { light, dark }

class MapboxStyle {
  static const light =
      'mapbox/streets-v12'; // giống Google nhất
  static const dark =
      'mapbox/dark-v11';

  static String byTheme(Brightness b) {
    return b == Brightness.dark ? dark : light;
  }
}

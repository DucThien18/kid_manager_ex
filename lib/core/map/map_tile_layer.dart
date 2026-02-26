import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';

class MapTileLayer {
  static final _accessToken =dotenv.env['ACCESS_TOKEN'] ?? '' ;

  static TileLayer mapbox({
    required Brightness brightness,
  }) {
    final styleId = brightness == Brightness.dark
        ? 'mapbox/dark-v11'
        : 'mapbox/streets-v12';

    return TileLayer(
      urlTemplate:
      'https://api.mapbox.com/styles/v1/$styleId/tiles/512/{z}/{x}/{y}@2x?access_token=$_accessToken',
      userAgentPackageName: 'com.example.kid_manager',
      tileSize: 512,
      zoomOffset: -1,
    );
  }
}
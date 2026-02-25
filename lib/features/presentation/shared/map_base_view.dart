import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kid_manager/core/map/map_tile_layer.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as osm;

import 'state/map_view_controller.dart';

class MapBaseView extends StatelessWidget {
  final List<Marker> markers;
  final List<Widget> overlays;

  const MapBaseView({
    super.key,
    this.markers = const [],
    this.overlays = const [],
  });

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewController>();
    final brightness = Theme.of(context).brightness;

    return Stack(
      children: [
        FlutterMap(
          mapController: mapVm.controller,
          options: MapOptions(
            initialCenter: const osm.LatLng(21.0285, 105.8542),
            initialZoom: 14,
            onMapReady: () {
              mapVm.markMapReady(); // 👈 CỰC KỲ QUAN TRỌNG
            },
            onPositionChanged: (_, hasGesture) {
              if (hasGesture) mapVm.setAutoFollow(false);
            },
          ),
          children: [
            MapTileLayer.mapbox(brightness: brightness),
            if (markers.isNotEmpty) MarkerLayer(markers: markers),
          ],
        ),

        ...overlays,
      ],

    );
  }
}

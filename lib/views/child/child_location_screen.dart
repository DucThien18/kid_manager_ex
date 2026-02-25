// lib/features/child/location/presentation/child_location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kid_manager/features/presentation/shared/map_base_view.dart';
import 'package:kid_manager/features/presentation/shared/state/map_view_controller.dart';
import 'package:kid_manager/viewmodels/location/child_location_view_model.dart';
import 'package:kid_manager/widgets/app/app_mode.dart';
import 'package:kid_manager/widgets/location/map_bottom_controls.dart';
import 'package:kid_manager/widgets/location/map_top_bar.dart';
import 'package:kid_manager/widgets/map/google_blue_dot.dart';
import 'package:latlong2/latlong.dart' as osm;
import 'package:provider/provider.dart';

class ChildLocationScreen extends StatefulWidget {
  const ChildLocationScreen({super.key});

  @override
  State<ChildLocationScreen> createState() => _ChildLocationScreenState();
}

class _ChildLocationScreenState extends State<ChildLocationScreen> {
  ChildLocationViewModel? _lastVm;
  VoidCallback? _vmListener;

  bool _initialFollowDone = false;

  // ================= START GPS ON ENTER =================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChildLocationViewModel>().startLocationSharing();
    });
  }

  // ================= ATTACH LISTENER SAFELY =================
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final vm = context.read<ChildLocationViewModel>();
    final mapVm = context.read<MapViewController>();

    if (_lastVm == vm) return;

    // cleanup old
    if (_lastVm != null && _vmListener != null) {
      _lastVm!.removeListener(_vmListener!);
    }

    _lastVm = vm;

    _vmListener = () {
      _handleInitialFollow(vm, mapVm);
      _maybeAutoFollow(vm, mapVm);
    };

    vm.addListener(_vmListener!);
  }

  // ================= INITIAL FOLLOW (1 TIME) =================
  void _handleInitialFollow(
      ChildLocationViewModel vm,
      MapViewController mapVm,
      ) {
    if (_initialFollowDone) return;

    final loc = vm.currentLocation;
    if (loc == null) return;

    if (!mapVm.autoFollow) return;
    if (vm.mode != LocationPlayMode.live) return;

    _initialFollowDone = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapVm.moveTo(
        osm.LatLng(loc.latitude, loc.longitude),
        zoom: 16,
      );
    });
  }

  // ================= CONTINUOUS AUTO FOLLOW =================
  void _maybeAutoFollow(
      ChildLocationViewModel vm,
      MapViewController mapVm,
      ) {
    final loc = vm.currentLocation;
    if (loc == null) return;

    if (!mapVm.autoFollow) return;
    if (vm.mode == LocationPlayMode.replay) return;
    if (loc.accuracy > 50) return;
    if (vm.motionState != MotionState.moving) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapVm.moveTo(
        osm.LatLng(loc.latitude, loc.longitude),
        zoom: 16,
      );
    });
  }

  // ================= CLEANUP =================
  @override
  void dispose() {
    if (_lastVm != null && _vmListener != null) {
      _lastVm!.removeListener(_vmListener!);
    }
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewController>();
    final locVm = context.watch<ChildLocationViewModel>();
    final loc = locVm.currentLocation;

    final markers = loc == null
        ? <Marker>[]
        : [
      Marker(
        point: osm.LatLng(loc.latitude, loc.longitude),
        width: 160,
        height: 160,
        child: GoogleBlueDot(accuracy: loc.accuracy),
      ),
    ];

    return Stack(
      children: [
        /// MAP
      MapBaseView(
        markers: markers,
        overlays: [
          MapTopBar(
            onMenuTap: () {  }, onAvatarTap: () {  },
          ),
          /// ===== BOTTOM CONTROLS (MY LOCATION) =====
          Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                top: false,
                child: MapBottomControls(
                  children: const [], // child screen không cần picker
                  onMyLocation: () {
                    final loc = locVm.currentLocation;
                    if (loc == null) return;

                    mapVm.setAutoFollow(true);
                    mapVm.moveTo(
                      osm.LatLng(loc.latitude, loc.longitude),
                      zoom: 16,
                    );
                  },
                ),
              ),
          ),
        ],
    ),


    /// SMART LOCATION BUTTON (ONE BUTTON ONLY)


        /// ERROR
        if (locVm.error != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _ErrorBanner(message: locVm.error!),
          ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red.shade600,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

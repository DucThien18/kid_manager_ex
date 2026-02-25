import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kid_manager/helpers/location/location_grouping.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/models/user/app_user_extensions.dart';
import 'package:kid_manager/viewmodels/location/parent_location_vm.dart';
import 'package:kid_manager/viewmodels/session/session_vm.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/widgets/common/avatar.dart';
import 'package:kid_manager/widgets/location/child_group_marker.dart';
import 'package:kid_manager/widgets/location/child_info_sheet.dart';
import 'package:kid_manager/widgets/location/child_marker.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as osm;

import 'package:kid_manager/features/presentation/shared/map_base_view.dart';
import 'package:kid_manager/features/presentation/shared/state/map_view_controller.dart';
import 'package:kid_manager/widgets/location/map_bottom_controls.dart';
import 'package:kid_manager/widgets/location/map_top_bar.dart';
import 'parent_children_list_screen.dart';

class ParentAllChildrenMapScreen extends StatefulWidget {
  const ParentAllChildrenMapScreen({super.key});

  @override
  State<ParentAllChildrenMapScreen> createState() =>
      _ParentAllChildrenMapView();
}


class _ParentAllChildrenMapView extends State<ParentAllChildrenMapScreen>
    with TickerProviderStateMixin  {

  late VoidCallback _userListener;
  late ParentLocationVm _locationVm;
  late MapViewController _mapVm;

  bool _didAutoZoom = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = context.read<SessionVM>();
      if (!session.isParent) return;

      final userVm = context.read<UserVm>();
      _locationVm = context.read<ParentLocationVm>();
      _mapVm = context.read<MapViewController>();
      if (userVm.children.isNotEmpty) {
        _locationVm.watchAllChildren(userVm.childrenIds);
      }

      _userListener = () {
        _locationVm.refreshWatching(userVm.childrenIds);
      };

      userVm.addListener(_userListener);
      _mapVm.addListener(_tryAutoZoom);
      _locationVm.addListener(_tryAutoZoom);

    });

  }


  @override
  void dispose() {
    _mapVm.removeListener(_tryAutoZoom);
    _locationVm.removeListener(_tryAutoZoom);
    context.read<UserVm>().removeListener(_userListener);
    super.dispose();
  }



  void _openChildrenList(BuildContext context) async{
    final selectedChild =await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: context.read<UserVm>(),
            ),
            ChangeNotifierProvider.value(
              value: context.read<ParentLocationVm>(),
            ),

          ],
          child:  ParentChildrenListScreen(),
        ),
      ),
    );

    if(selectedChild == null || !mounted ){
      return;
    }
    _focusAndShowChild(selectedChild);
  }

  void _openChildInfo(
      BuildContext context,
      AppUser child,
      ) {
    final locVm = context.read<ParentLocationVm>();
    final mapVm = context.read<MapViewController>();

    final latest = locVm.childrenLocations[child.uid];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChildInfoSheet(
        child: child,
        latest: latest,
        isSearching: mapVm.isRouteActive,
        onOpenChat: () {
          // TODO: push chat screen
        },
        onSendQuickMessage: (msg) async {
          // TODO: hook chat repo
        },
        onToggleSearch: () async {
          Navigator.pop(context);

          final history =
          await locVm.loadLocationHistory(child.uid);

          final points = history
              .map((e) => osm.LatLng(e.latitude, e.longitude))
              .toList();

          mapVm.toggleRoute(points);
        },
      ),
    );
  }

  void _openChildrenAtSamePlace(
      BuildContext context,
      List<AppUser> children,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: children.map((child) {
          return ListTile(
            leading: AppAvatar(user: child, size: 36),
            title: Text(child.displayLabel),
            onTap: () {
              Navigator.pop(context);
              _openChildInfo(context, child);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _focusAndShowChild(AppUser child) async {
    final loc = _locationVm.childrenLocations[child.uid];
    if (loc == null) return;

    final point = osm.LatLng(loc.latitude, loc.longitude);

    // 🔍 TÌM GROUP CHỨA CHILD NÀY
    final groups = groupChildrenByDistance(
      children: context.read<UserVm>().children,
      locations: _locationVm.childrenLocations,
      thresholdMeters: 5,
    );

    final group = groups.firstWhere(
          (g) => g.children.any((c) => c.uid == child.uid),
      orElse: () => throw Exception('Group not found'),
    );

    // ===== CASE 1: CHILD NẰM TRONG GROUP (>1) =====
    if (group.children.length > 1) {
      // 👉 zoom vào group trước
      _mapVm.fitPoints(
        group.children
            .map((c) {
          final l = _locationVm.childrenLocations[c.uid]!;
          return osm.LatLng(l.latitude, l.longitude);
        })
            .toList(),
      );

      // 👉 mở picker group (cho user chọn)
      _openChildrenAtSamePlace(context, group.children);
      return;
    }

    // ===== CASE 2: CHILD ĐƠN =====
    await _mapVm.animateTo(
      this,
      point,
      targetZoom: 17,
    );
    if (!mounted) return;
    _openChildInfo(context, child);
  }

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewController>();
    final userVm = context.watch<UserVm>();
    final children = context.select<UserVm, List<AppUser>>(
          (vm) => vm.children,
    );
    final mapReady = context.select<MapViewController, bool>(
          (vm) => vm.mapReady,
    );

    final locations = context.select<ParentLocationVm, Map<String, LocationData>>(
          (vm) => vm.childrenLocations,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_didAutoZoom) return;
      if (!mapReady) return;
      if (locations.isEmpty) return;

      _didAutoZoom = true;

      final points = locations.values
          .map((e) => osm.LatLng(e.latitude, e.longitude))
          .toList();

      // 👇 QUAN TRỌNG: đẩy sang frame tiếp theo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final mapVm = context.read<MapViewController>();

        if (points.length == 1) {
          mapVm.moveTo(points.first, zoom: 17);
        } else {
          mapVm.fitPoints(points);
        }
      });
    });

    final groups = groupChildrenByDistance(
      children: children,
      locations: locations,
      thresholdMeters: 5,
    );

    // debugPrint("PROFILE CHILDREN = ${userVm.children.length}");
    // debugPrint("LOCATION WATCHING = ${locations}");

    final markers = groups.map((group) {
      if (group.children.length == 1) {
        final child = group.children.first;
        final loc = locations[child.uid]!;

        return Marker(
          point: osm.LatLng(loc.latitude, loc.longitude),
          width: 80,
          height: 96,
          child: ChildMarker(
            child: child,
            location: loc,
            onTap: () => _focusAndShowChild(child),

          ),
        );
      }

      return Marker(
        point: group.center,
        width: 100,
        height: 80,
        child: ChildGroupMarker(
          children: group.children,
          onTap: () =>
              _openChildrenAtSamePlace(context, group.children),
        ),
      );
    }).toList();

    return Scaffold(
      body: MapBaseView(
        markers: markers,
        overlays: [
          /// ================= TOP BAR =================
          MapTopBar(
            onMenuTap:  () => _openChildrenList(context),
            onAvatarTap: () {},
          ),

          /// ================= BOTTOM CONTROLS =================
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: MapBottomControls(
                children: userVm.children,
                onTapChild: (child) {
                  _focusAndShowChild(child);
                },
                onMore: () => _openChildrenList(context),
                onMyLocation: () {
                  mapVm.fitPoints(
                    markers.map((m) => m.point).toList(),
                  );
                },
              ),
            ),
          ),
        ],

      ),

    );

  }

  void _tryAutoZoom() {
    if (!mounted) return;
    if (_didAutoZoom) return;
    if (!_mapVm.mapReady) return;

    final locations = _locationVm.childrenLocations;
    if (locations.isEmpty) return;

    _didAutoZoom = true;

    final points = locations.values
        .map((e) => osm.LatLng(e.latitude, e.longitude))
        .toList();

    debugPrint("MOUNT = ${points.length}");

    if (points.length == 1) {
      _mapVm.moveTo(points.first, zoom: 17);
    } else {
      _mapVm.fitPoints(points);
    }
  }


}







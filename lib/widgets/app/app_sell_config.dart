import 'package:kid_manager/features/presentation/shared/app_bottom_bar_config.dart';
import 'package:kid_manager/features/presentation/shared/state/map_view_controller.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';
import 'package:kid_manager/repositories/user_repository.dart';
import 'package:kid_manager/services/location/location_service.dart';
import 'package:kid_manager/viewmodels/location/child_location_view_model.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/views/child/child_location_screen.dart';
import 'package:kid_manager/views/child/child_notification_screen.dart';
import 'package:kid_manager/views/parent/dashboard/app_management_screen.dart';
import 'package:kid_manager/views/parent/location/parent_location_screen.dart';
import 'package:kid_manager/views/parent/parent_calendar_screen.dart';
import 'package:kid_manager/views/parent/parent_notification_screen.dart';
import 'package:kid_manager/views/parent/schedule/schedule_screen.dart';
import 'package:kid_manager/views/personal_info_screen.dart';
import 'package:provider/provider.dart';

class AppShellConfig {
  final List<BottomTabConfig> tabs;

  const AppShellConfig(this.tabs);

  // ============================================================
  // PARENT
  // ============================================================

  static AppShellConfig parent() => AppShellConfig([
    BottomTabConfig(
      iconAsset: 'assets/icons/location.svg',
      root: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => MapViewController())],
        child: const ParentAllChildrenMapScreen(),
      ),
    ),

    BottomTabConfig(
      iconAsset: 'assets/icons/dashboard.svg',
      root: const AppManagementScreen(),
    ),

    BottomTabConfig(
      iconAsset: 'assets/icons/sms.svg',
      root: const ParentNotificationScreen(),
    ),

    BottomTabConfig(
      iconAsset: 'assets/icons/bell.svg',
      root: const ParentNotificationScreen(),
    ),
    BottomTabConfig(
      iconAsset: 'assets/icons/calendar.svg',
      root: const ScheduleScreen(),
    ),
    BottomTabConfig(
      iconAsset: 'assets/icons/user_nav.svg',
      root: const PersonalInfoScreen(),
    ),
  ]);

  // ============================================================
  // CHILD
  // ============================================================

  static AppShellConfig child() => AppShellConfig([
    BottomTabConfig(
      iconAsset: 'assets/icons/location.svg',
      root: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ChildLocationViewModel(
              context.read<LocationRepository>(),
              context.read<LocationServiceInterface>(),
            ),
          ),
          ChangeNotifierProvider(create: (_) => MapViewController()),
        ],
        child: const ChildLocationScreen(),
      ),
    ),
    BottomTabConfig(
      iconAsset: 'assets/icons/bell.svg',
      root: const ChildNotificationScreen(),
    ),
    BottomTabConfig(
      iconAsset: 'assets/icons/user_nav.svg',
      root: const PersonalInfoScreen(),
    ),
  ]);
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kid_manager/repositories/app_management_repository.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';
import 'package:kid_manager/repositories/location/location_repository_impl.dart';

import 'package:kid_manager/repositories/user_repository.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';
import 'package:kid_manager/services/location/location_service.dart';
import 'package:kid_manager/services/app_installed_service.dart';
import 'package:kid_manager/services/permission_service.dart';
import 'package:kid_manager/services/secondary_auth_service.dart';
import 'package:kid_manager/services/storage_service.dart';
import 'package:kid_manager/services/usage_sync_service.dart';
import 'package:kid_manager/viewmodels/app_init_vm.dart';
import 'package:kid_manager/viewmodels/app_management_vm.dart';
import 'package:kid_manager/viewmodels/location/parent_location_vm.dart';
import 'package:kid_manager/viewmodels/session/session_vm.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:provider/provider.dart';

import 'core/alert_service.dart';
import 'core/constants.dart';
import 'core/theme.dart';

import 'features/sessionguard/session_guard.dart';
import 'services/firebase_auth_service.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/auth_vm.dart';

import 'repositories/schedule_repository.dart';
import 'viewmodels/schedule_vm.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    final storage = context.read<StorageService>();

    // services
    final secondaryAuthService = SecondaryAuthService();
    final permissionService = PermissionService();
    final appInstalledService = AppInstalledService();
    final usageService = UsageSyncService(FirebaseFirestore.instance);

    // repositories
    final userRepo = UserRepository(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
      secondaryAuthService,
    );
    final authRepo = AuthRepository(authService, userRepo);
    final scheduleRepo = ScheduleRepository(FirebaseFirestore.instance);
    final appRepo = AppManagementRepository(
      appInstalledService,
      usageService,
      FirebaseFirestore.instance,
    );

    return MultiProvider(
      providers: [
        // services
        Provider.value(value: authService),
        Provider.value(value: permissionService),
        Provider.value(value: appInstalledService),
        Provider.value(value: usageService),

        // repositories
        Provider.value(value: userRepo),
        Provider.value(value: authRepo),
        Provider.value(value: appRepo),

        // ViewModels
        ChangeNotifierProvider(create: (_) => AuthVM(authRepo)),
        ChangeNotifierProvider(
          create: (_) => AppInitVM(storage, permissionService),
        ),

        ChangeNotifierProvider(create: (context) => AppManagementVM(appRepo)),
        ChangeNotifierProvider(
          create: (context) =>
              ScheduleViewModel(scheduleRepo, context.read<AuthVM>()),
        ),

        /// LOCATION SERVICE
        Provider<LocationServiceInterface>(
          create: (_) => LocationServiceImpl(),
        ),

        ChangeNotifierProvider<SessionVM>(
          create: (context) => SessionVM(context.read<AuthRepository>()),
        ),

        /// LOCATION REPOSITORY
        Provider<LocationRepository>(create: (_) => LocationRepositoryImpl()),
        ChangeNotifierProvider<UserVm>(
          create: (context) => UserVm(
            context.read<UserRepository>(),
            context.read<StorageService>(),
          ),
        ),
        ChangeNotifierProvider<ParentLocationVm>(
          create: (context) =>
              ParentLocationVm(context.read<LocationRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        navigatorKey: AlertService.navigatorKey,
        theme: AppTheme.light(),
        themeMode: ThemeMode.system,
        home: const SessionGuard(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/widgets/app/app_mode.dart';
import 'package:kid_manager/features/sessionguard/splash_screen.dart';
import 'package:kid_manager/features/sessions/sessionstatus.dart';
import 'package:kid_manager/viewmodels/session/session_vm.dart';
import 'package:kid_manager/views/auth/login_screen.dart';
import 'package:kid_manager/widgets/app/app_shell.dart';
import 'package:provider/provider.dart';

class SessionGuard extends StatefulWidget {
  const SessionGuard({super.key});

  @override
  State<SessionGuard> createState() => _SessionGuardState();
}

class _SessionGuardState extends State<SessionGuard> {
  SessionStatus? _lastStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionVM>(
      builder: (context, session, _) {
        // ===== HANDLE SIDE EFFECT ONCE =====
        if (_lastStatus != session.status) {
          _lastStatus = session.status;

          if (session.status == SessionStatus.authenticated &&
              session.isParent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<UserVm>()
                  .watchChildren(session.user!.uid);
            });
          }
        }

        // ===== UI =====
        switch (session.status) {
          case SessionStatus.booting:
            return const SplashScreen();

          case SessionStatus.unauthenticated:
            return const LoginScreen();

          case SessionStatus.authenticated:
            return AppShell(
              mode: session.isParent
                  ? AppMode.parent
                  : AppMode.child,
            );
        }
      },
    );
  }
}



import 'package:flutter/material.dart';
import 'package:kid_manager/widgets/app/app_mode.dart';

import 'package:kid_manager/widgets/app/app_bottom_nav.dart';
import 'package:kid_manager/widgets/app/app_sell_config.dart';

class AppShell extends StatefulWidget {
  final AppMode mode;

  const AppShell({super.key, required this.mode});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final session = context.read<SessionVM>();
  //
  //     if (session.isParent) {
  //       final parentUid = session.user!.uid;
  //
  //       context
  //           .read<ParentDashboardVm>()
  //           .watchChildren(parentUid);
  //     }
  //   });
  // }

  late final AppShellConfig _config =
  widget.mode == AppMode.parent
      ? AppShellConfig.parent()
      : AppShellConfig.child();

  late final _navKeys =
  List.generate(_config.tabs.length, (_) => GlobalKey<NavigatorState>());

  Widget _buildTab(int i) {
    return Navigator(
      key: _navKeys[i],
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => _config.tabs[i].root),
    );
  }

  Future<void> _onNavTap(int i) async {
    if (i == _index) {
      _navKeys[i].currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => _index = i);
  }

  Future<bool> _onWillPop() async {
    final nav = _navKeys[_index].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(
      _config.tabs.length,
          (i) => _buildTab(i),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: _index, children: tabs),
        bottomNavigationBar: AppBottomNav(
          items: _config.tabs
              .map((t) => BottomNavItem(iconAsset: t.iconAsset))
              .toList(),
          currentIndex: _index,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

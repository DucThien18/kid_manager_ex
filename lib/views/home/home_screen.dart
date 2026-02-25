import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_vm.dart';
import '../../core/alert_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await AlertService.confirm(
      title: 'Đăng xuất',
      message: 'Bạn có chắc muốn đăng xuất không?',
    );

    if (!confirm) return;

    await context.read<AuthVM>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthVM>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 64),
            const SizedBox(height: 16),
            Text(
              'Xin chào 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (authVM.user?.email != null)
              Text(authVM.user!.email!),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                // TODO: navigate to child list screen
              },
              child: const Text('Quản lý con'),
            ),
          ],
        ),
      ),
    );
  }
}

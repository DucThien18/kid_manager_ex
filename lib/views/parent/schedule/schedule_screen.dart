import 'package:flutter/material.dart';
import 'package:kid_manager/core/storage_keys.dart';
import 'package:kid_manager/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:kid_manager/models/app_user.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../viewmodels/schedule_vm.dart';
import '../../../viewmodels/user_vm.dart';
import '../../../views/parent/schedule/add_schedule_sheet.dart';
import '../../../widgets/parent/create_schedule_button.dart';
import '../../../widgets/parent/schedule_calendar.dart';
import '../../../widgets/parent/schedule_list.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _didInit = false;

  void _openAddScheduleSheet({
    required BuildContext context,
    required String childId,
    required DateTime selectedDate,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddScheduleScreen(
              childId: childId,
              selectedDate: selectedDate,
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userVm = context.read<UserVm>();
      final storage = context.read<StorageService>();
      final scheduleVm = context.read<ScheduleViewModel>();

      final parentUid = storage.getString(StorageKeys.uid);
      if (parentUid == null) return;

      userVm.watchChildren(parentUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleVm = context.watch<ScheduleViewModel>();
    final userVm = context.watch<UserVm>();

    final List<AppUser> children = userVm.children;

    // AUTO SELECT BÉ ĐẦU TIÊN
    if (scheduleVm.selectedChildId == null && children.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scheduleVm.setChild(children.first.uid);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkText),
          onPressed: () {},
        ),
        title: const Text(
          'Lịch trình',
          style: AppTextStyles.scheduleAppBarTitle,
        ),
        centerTitle: true,

        // ✅ danh sách con thật
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: children.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text('Chưa có bé'),
                    ),
                  )
                : PopupMenuButton<String>(
                    onSelected: (childUid) {
                      scheduleVm.setChild(childUid);
                      // nếu scheduleVm có load theo child/date thì gọi ở đây
                      // scheduleVm.loadSchedules();
                    },
                    itemBuilder: (_) => children
                        .map(
                          (c) => PopupMenuItem(
                            value: c.uid,
                            child: Text(c.displayName ?? c.email ?? c.uid),
                          ),
                        )
                        .toList(),
                    child: CircleAvatar(
                      radius: 18,
                      // nếu bạn có avatarUrl thì dùng NetworkImage ở đây
                      child: Text(
                        _initialOf(children, scheduleVm.selectedChildId),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          const ScheduleCalendar(),
          const SizedBox(height: 16),
          const Expanded(child: ScheduleList()),
          CreateScheduleButton(
            onTap: () {
              final selectedChildId = scheduleVm.selectedChildId;
              if (selectedChildId == null) return;

              _openAddScheduleSheet(
                context: context,
                childId: selectedChildId,
                selectedDate: scheduleVm.selectedDate,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _initialOf(List<AppUser> children, String? selectedId) {
    if (children.isEmpty) return '?';

    final AppUser selected = selectedId == null
        ? children.first
        : children.firstWhere(
            (c) => c.uid == selectedId,
            orElse: () => children.first,
          );

    final name = (selected.displayName ?? selected.email ?? '').trim();
    if (name.isEmpty) return 'B';
    return name[0].toUpperCase();
  }
}

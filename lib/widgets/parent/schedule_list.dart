import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_text_styles.dart';
import '../../../../models/schedule.dart';
import '../../../../utils/schedule_utils.dart';
import '../../../../viewmodels/schedule_vm.dart';
import '../../views/parent/schedule/edit_schedule_sheet.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    if (vm.selectedChildId == null) {
      return const Center(child: Text('Vui lòng chọn bé', style: AppTextStyles.body));
    }

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    if (vm.schedules.isEmpty) {
      return const Center(
        child: Text('Không có lịch trong ngày', style: AppTextStyles.body),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: vm.schedules.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ScheduleItem(schedule: vm.schedules[i]),
      ),
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final Schedule schedule;

  const ScheduleItem({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final duration =
        '${schedule.startAt.hour}:${schedule.startAt.minute.toString().padLeft(2, '0')}-'
        '${schedule.endAt.hour}:${schedule.endAt.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF00B383),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(duration, style: AppTextStyles.scheduleItemTimeRange),
              const Spacer(),
              _ActionIcon(
                asset: 'assets/images/edit.png',
                width: 18,
                height: 18,
                onTap: () => _openEditSheet(context),
              ),
              const SizedBox(width: 10),
              _ActionIcon(
                asset: 'assets/images/ic_delete.png',
                onTap: () => _deleteSchedule(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(schedule.title, style: AppTextStyles.scheduleItemTitle),
          if ((schedule.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(schedule.description!, style: AppTextStyles.scheduleItemTime),
          ],
        ],
      ),
    );
  }

  Future<void> _openEditSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditScheduleScreen(schedule: schedule),
        ),
      ),
    );
  }

  Future<void> _deleteSchedule(BuildContext context) async {
  final vm = context.read<ScheduleViewModel>();

  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Xóa lịch trình'),
      content: const Text('Bạn có chắc muốn xóa?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xóa', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  // ✅ lưu context của màn hình trước khi list rebuild
  final rootContext = Navigator.of(context, rootNavigator: true).context;

  showDialog(
    context: rootContext,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await vm.deleteSchedule(schedule.id);

    // đóng loading
    Navigator.of(rootContext, rootNavigator: true).pop();

    // ✅ dùng rootContext để show popup
    await showScheduleSuccess(rootContext, 'Bạn đã xóa thành công');
  } catch (_) {
    Navigator.of(rootContext, rootNavigator: true).pop();
    ScaffoldMessenger.of(rootContext).showSnackBar(
      const SnackBar(content: Text('Có lỗi xảy ra')),
    );
  }
}
}

class _ActionIcon extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.asset,
    required this.onTap,
    this.width = 22,
    this.height = 22,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(asset, width: width, height: height),
    );
  }
}
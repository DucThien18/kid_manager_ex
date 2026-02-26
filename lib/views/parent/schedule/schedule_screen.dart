import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../viewmodels/schedule_vm.dart';
import '../../../views/parent/schedule/add_schedule_sheet.dart';
import '../../../widgets/parent/create_schedule_button.dart';
import '../../../widgets/parent/schedule_calendar.dart';
import '../../../widgets/parent/schedule_list.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  void _openAddScheduleSheet({
    required BuildContext context,
    required String childId,
    required DateTime selectedDate,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // ignore: deprecated_member_use
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddScheduleScreen(childId: childId, selectedDate: selectedDate),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkText),
          onPressed: () {},
        ),
        title: const Text('Lịch trình', style: AppTextStyles.scheduleAppBarTitle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<String>(
              onSelected: vm.setChild,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'child_1', child: Text('Bé An')),
                PopupMenuItem(value: 'child_2', child: Text('Bé Bình')),
              ],
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(
                  vm.selectedChildId == 'child_2'
                      ? 'assets/images/avt2.png'
                      : 'assets/images/avt1.png',
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
              final selectedChildId = vm.selectedChildId;
              if (selectedChildId == null) return;

              _openAddScheduleSheet(
                context: context,
                childId: selectedChildId,
                selectedDate: vm.selectedDate,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
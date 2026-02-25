import 'package:flutter/material.dart';
import 'package:kid_manager/views/parent/schedule/schedule_success_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/schedule.dart';
import '../../../viewmodels/schedule_vm.dart';
import 'add_schedule_sheet.dart';
import 'edit_schedule_sheet.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>(); // ✅ ĐỔI Ở ĐÂY

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // ⬅️ MENU
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkText),
          onPressed: () {},
        ),

        title: const Text(
          'Lịch trình',
          style: AppTextStyles.scheduleAppBarTitle,
        ),
        centerTitle: true,

        // 👶 CHỌN BÉ BẰNG AVATAR
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                vm.setChild(value);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'child_1', child: Text('Bé An')),
                const PopupMenuItem(value: 'child_2', child: Text('Bé Bình')),
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
          const _Calendar(),
          const SizedBox(height: 16),
          const Expanded(child: _ScheduleList()),
          _CreateScheduleButton(
            onTap: () {
              final vm = context.read<ScheduleViewModel>();

              if (vm.selectedChildId == null) return;
              openAddScheduleSheet(
                context: context,
                childId: vm.selectedChildId!,
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

class _Calendar extends StatefulWidget {
  const _Calendar({super.key});

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week; //Hiển thị tuần

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          TableCalendar(
            locale: 'vi_VN',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: vm.selectedDate,
            selectedDayPredicate: (day) => isSameDay(day, vm.selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              vm.setDate(selectedDay);
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            headerVisible: false,
            daysOfWeekHeight: 40,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              selectedDecoration: const BoxDecoration(
                color: AppColors.calendarSelection,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              defaultTextStyle: AppTextStyles.scheduleDayNumber,
              weekendTextStyle: AppTextStyles.scheduleDayNumber,
              outsideTextStyle: const TextStyle(
                color: Color(0xFFBCC1CD),
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: AppTextStyles.scheduleDayName,
              weekendStyle: AppTextStyles.scheduleDayName,
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                String shortName = '';
                switch (day.weekday) {
                  case DateTime.monday:
                    shortName = 'T2';
                    break;
                  case DateTime.tuesday:
                    shortName = 'T3';
                    break;
                  case DateTime.wednesday:
                    shortName = 'T4';
                    break;
                  case DateTime.thursday:
                    shortName = 'T5';
                    break;
                  case DateTime.friday:
                    shortName = 'T6';
                    break;
                  case DateTime.saturday:
                    shortName = 'T7';
                    break;
                  case DateTime.sunday:
                    shortName = 'CN';
                    break;
                }
                return Center(
                  child: Text(
                    shortName,
                    style: AppTextStyles.scheduleDayName.copyWith(
                      color: const Color(0xFFBCC1CD),
                    ),
                  ),
                );
              },
              markerBuilder: (context, date, events) {
                if (!vm.hasSchedule(date)) return const SizedBox.shrink();

                return Positioned(
                  bottom: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      (vm
                                  .monthSchedules[DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                  )]
                                  ?.length ??
                              1)
                          .clamp(1, 3),
                      (_) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B383),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            pageAnimationEnabled: true,
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 10 &&
                  _calendarFormat == CalendarFormat.week) {
                setState(() => _calendarFormat = CalendarFormat.month);
              } else if (details.delta.dy < -10 &&
                  _calendarFormat == CalendarFormat.month) {
                setState(() => _calendarFormat = CalendarFormat.week);
              }
            },
            child: Container(
              width: double.infinity,
              height: 20,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<ScheduleViewModel>(
      builder: (context, vm, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  vm.changeMonth(
                    DateTime(vm.selectedDate.year, vm.selectedDate.month - 1),
                  );
                },
                icon: const Icon(Icons.chevron_left, color: AppColors.darkText),
              ),
              Column(
                children: [
                  Text(
                    'Tháng ${vm.selectedDate.month}',
                    style: AppTextStyles.scheduleMonthYear,
                  ),
                  Text(
                    '${vm.selectedDate.year}',
                    style: AppTextStyles.scheduleYear,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  vm.changeMonth(
                    DateTime(vm.selectedDate.year, vm.selectedDate.month + 1),
                  );
                },
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChildSelector extends StatelessWidget {
  final ScheduleViewModel vm;

  const _ChildSelector({required this.vm});

  @override
  Widget build(BuildContext context) {
    // TODO: thay bằng child list thật
    final children = const [
      {'id': 'child_1', 'name': 'Bé An'},
      {'id': 'child_2', 'name': 'Bé Bình'},
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<String>(
        value: vm.selectedChildId,
        hint: const Text('Chọn bé'),
        items: children
            .map(
              (c) => DropdownMenuItem(value: c['id'], child: Text(c['name']!)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) vm.setChild(value);
        },
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    if (vm.selectedChildId == null) {
      return const Center(
        child: Text('Vui lòng chọn bé', style: AppTextStyles.body),
      );
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
      itemBuilder: (_, i) {
        final s = vm.schedules[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ScheduleItem(schedule: s),
        );
      },
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final Schedule schedule;

  const _ScheduleItem({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ScheduleViewModel>();

    final startTime =
        '${schedule.startAt.hour.toString().padLeft(2, '0')}:${schedule.startAt.minute.toString().padLeft(2, '0')}';

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
      child: Stack(
        children: [
          /// ===== CONTENT =====
          Column(
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
                ],
              ),

              const SizedBox(height: 8),

              Text(schedule.title, style: AppTextStyles.scheduleItemTitle),

              const SizedBox(height: 4),

              Text(
                'Bắt đầu lúc $startTime',
                style: AppTextStyles.scheduleItemTime,
              ),
            ],
          ),

          /// ===== ACTION ICONS (TOP RIGHT) =====
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withValues(alpha: 0.3),
                      builder: (_) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: EditScheduleScreen(schedule: schedule),
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/images/edit.png',
                    width: 18,
                    height: 18,
                  ),
                ),

                const SizedBox(width: 12),

                GestureDetector(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Xóa lịch trình"),
                        content: const Text("Bạn có chắc muốn xóa?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Xóa",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    /// 1️⃣ Show loading
                    showDialog(
                      context: context,
                      useRootNavigator: true,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      /// 2️⃣ Delete
                      await vm.deleteSchedule(schedule.id);

                      if (!context.mounted) return;

                      /// 3️⃣ Hide loading
                      Navigator.of(context, rootNavigator: true).pop();

                      /// 4️⃣ Show success popup
                      await showSuccessPopup(
                        context,
                        message: "Bạn đã xóa thành công",
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      Navigator.of(context, rootNavigator: true).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Có lỗi xảy ra")),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/images/ic_delete.png',
                    width: 22,
                    height: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showSuccessPopup(
    BuildContext context, {
    required String message,
  }) {
    return showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierLabel: "Success",
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(child: ScheduleSuccessSheet(message: message));
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _CreateScheduleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateScheduleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.calendarSelection,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            '+ Thêm sự kiện',
            style: AppTextStyles.scheduleCreateButton,
          ),
        ),
      ),
    );
  }
}

void openAddScheduleSheet({
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

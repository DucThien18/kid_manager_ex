import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';
import '../../../../viewmodels/schedule_vm.dart';

class ScheduleCalendar extends StatefulWidget {
  const ScheduleCalendar({super.key});

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

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
          const _CalendarHeader(),
          TableCalendar(
            locale: 'vi_VN',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: vm.selectedDate,
            selectedDayPredicate: (day) => isSameDay(day, vm.selectedDate),
            onDaySelected: (selectedDay, _) => vm.setDate(selectedDay),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
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
              dowBuilder: (context, day) => Center(
                child: Text(
                  _weekdayShortName(day),
                  style: AppTextStyles.scheduleDayName.copyWith(
                    color: const Color(0xFFBCC1CD),
                  ),
                ),
              ),
              markerBuilder: (_, date, __) {
                if (!vm.hasSchedule(date)) return const SizedBox.shrink();

                final key = DateTime(date.year, date.month, date.day);
                final markerCount = (vm.monthSchedules[key]?.length ?? 1).clamp(1, 3);

                return Positioned(
                  bottom: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      markerCount,
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
              if (details.delta.dy > 10 && _calendarFormat == CalendarFormat.week) {
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

  String _weekdayShortName(DateTime day) {
    switch (day.weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => vm.changeMonth(
              DateTime(vm.selectedDate.year, vm.selectedDate.month - 1),
            ),
            icon: const Icon(Icons.chevron_left, color: AppColors.darkText),
          ),
          Column(
            children: [
              Text('Tháng ${vm.selectedDate.month}', style: AppTextStyles.scheduleMonthYear),
              Text('${vm.selectedDate.year}', style: AppTextStyles.scheduleYear),
            ],
          ),
          IconButton(
            onPressed: () => vm.changeMonth(
              DateTime(vm.selectedDate.year, vm.selectedDate.month + 1),
            ),
            icon: const Icon(Icons.chevron_right, color: AppColors.darkText),
          ),
        ],
      ),
    );
  }
}

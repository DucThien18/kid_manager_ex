import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/app/app_overlay_sheet.dart';

class UsageTimeEditScreen extends StatefulWidget {
  final String appId;
  const UsageTimeEditScreen({super.key, required this.appId});

  @override
  State<UsageTimeEditScreen> createState() => _UsageTimeEditScreenState();
}

class _UsageTimeEditScreenState extends State<UsageTimeEditScreen> {
  bool unlimited = false;
  int minutes = 60;

  @override
  void initState() {
    super.initState();
    _fillDotsDemo();
    final now = DateTime.now();
    _gridMonth = DateTime(now.year, now.month, 1);
    _headerMonth = _gridMonth;
  }

  late DateTime _gridMonth;
  late DateTime _headerMonth;
  DateTime? _selectedDate;
  DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

  final Map<DateTime, int> _dotsByDay = {};

  void _fillDotsDemo() {
    // final now = DateTime.now();
    final now = DateTime(DateTime.now().year, DateTime.now().month, 27);

    _dotsByDay[_d(now)] = 3; // hôm nay 3 chấm
    _dotsByDay[_d(now.add(const Duration(days: 1)))] = 1;
    _dotsByDay[_d(now.add(const Duration(days: 2)))] = 2;

    _dotsByDay[_d(DateTime(now.year, now.month, 5))] = 1;
    _dotsByDay[_d(DateTime(now.year, now.month, 12))] = 2;
    _dotsByDay[_d(DateTime(now.year, now.month, 18))] = 3;

    // debugPrint(_dotsByDay.toString());
  }

  bool checked = true;

  @override
  Widget build(BuildContext context) {
    return AppOverlaySheet(
      height: 640,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 6),
                  Text(
                    'Cài đặt thời gian sử dụng',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF222B45),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.10,
                    ),
                  ),

                  const SizedBox(height: 18),
                  Container(
                    width: 350,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Cho phép sử dụng',
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.38,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: checked,
                        onChanged: (v) => setState(() => checked = v),

                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF2F6BFF),
                        inactiveThumbColor: const Color(0xFF8F9BB3),
                        inactiveTrackColor: const Color(0xFFE4E9F2),

                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ), // ✅ bỏ loang
                        splashRadius: 0, // ✅ bỏ splash
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFEDF1F7)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Giờ bắt đầu',
                                  style: TextStyle(
                                    color: Color(0xFF8F9BB3),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icons/icon_clock.svg",
                                width: 18,
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFEDF1F7)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Giờ kết thúc',
                                  style: TextStyle(
                                    color: Color(0xFF8F9BB3),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icons/icon_clock.svg",
                                width: 18,
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Chọn ngày được phép',
                      style: TextStyle(
                        color: Color(0xFF222B45),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.19,
                      ),
                    ),
                  ),

                  const SizedBox(height: 27),
                  buildCalendar(
                    month: _gridMonth,
                    headerMonth: _headerMonth,
                    selected: _selectedDate,
                    dotsByDay: _dotsByDay,

                    onMonthChanged: (m) => setState(() {
                      _gridMonth = DateTime(m.year, m.month, 1);
                      _headerMonth = _gridMonth;
                    }),
                    onDayTap: (cellDate) => setState(() {
                      _selectedDate = cellDate;
                      _headerMonth = DateTime(
                        cellDate.year,
                        cellDate.month,
                        1,
                      );
                    }),
                  ),

                  const SizedBox(height: 14),
                  Center(
                    child: Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: "Hủy",
                          width: 172,
                          height: 50,
                          backgroundColor: Color(0xFF3A7DFF),
                          fontSize: 16,
                          lineHeight: 1.38,
                          fontWeight: FontWeight.w700,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: "Lưu",
                          width: 172,
                          height: 50,
                          backgroundColor: Color(0xFF3A7DFF),
                          fontSize: 16,
                          lineHeight: 1.38,
                          fontWeight: FontWeight.w700,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCalendar({
  required DateTime month,
  required DateTime headerMonth,
  required DateTime? selected,
  required void Function(DateTime newMonth) onMonthChanged,
  required void Function(DateTime day) onDayTap,
  required Map<DateTime, int> dotsByDay,
}) {
  final firstDayOfMonth = DateTime(month.year, month.month, 1);
  final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

  // Thứ 2 = 1 ... CN = 7, mình muốn grid bắt đầu từ T2
  final int leading = (firstDayOfMonth.weekday - DateTime.monday) % 7; // 0..6
  final totalDays = lastDayOfMonth.day;
  final totalCells = 35;

  DateTime norm(DateTime d) => DateTime(d.year, d.month, d.day);
  final sel = selected == null ? null : norm(selected);

  String monthTitle(int m) => 'Tháng $m';
  const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header: arrows + month/year
      Row(
        children: [
          _monthNavButton(
            icon: Icons.chevron_left,
            onTap: () =>
                onMonthChanged(DateTime(month.year, month.month - 1, 1)),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  monthTitle(headerMonth.month),
                  style: TextStyle(
                    color: const Color(0xFF222B45),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0.80,
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  '${headerMonth.year}',
                  style: TextStyle(
                    color: const Color(0xFF8F9BB3),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
          _monthNavButton(
            icon: Icons.chevron_right,
            onTap: () =>
                onMonthChanged(DateTime(month.year, month.month + 1, 1)),
          ),
        ],
      ),

      // Weekday row
      GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 30 / 29, // giống cell của bạn
        children: weekdays
            .map(
              (w) => Center(
                child: Text(
                  w,
                  style: const TextStyle(
                    color: Color(0xFF8F9BB3),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.23,
                  ),
                ),
              ),
            )
            .toList(),
      ),

      // Grid days
      GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCells,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, i) {
          // ngày đầu của grid = firstDayOfMonth lùi lại "leading" ngày
          final cellDate = firstDayOfMonth.subtract(
            Duration(days: leading - i),
          );
          final inMonth = cellDate.month == month.month;

          final isSelected = sel != null && norm(cellDate) == sel;
          final dots = dotsByDay[norm(cellDate)] ?? 0;

          return _dayCell(
            label: '${cellDate.day}',
            inMonth: inMonth, // để render mờ ngày ngoài tháng
            selected: isSelected,
            dots: dots,
            onTap: () => onDayTap(cellDate),
          );
        },
      ),
    ],
  );
}

Widget _monthNavButton({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
    child: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEDF1F7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: const Color(0xFF4A4A4A)),
    ),
  );
}

Widget _dayCell({
  required String label,
  required bool inMonth,
  required bool selected,
  required int dots,
  VoidCallback? onTap,
}) {
  final bg = selected ? const Color(0xFF2F6BFF) : Colors.transparent;

  final textColor = selected
      ? Colors.white
      : (inMonth ? const Color(0xFF1F2A4A) : const Color(0xFF8F9BB3));

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 29,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (dots > 0)
          Opacity(
            opacity: inMonth ? 1 : 0.5, // chấm cũng mờ nếu ngoài tháng
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dots.clamp(0, 3),
                (_) => Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1BD8A4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

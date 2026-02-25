import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/schedule.dart';
import '../../parent/schedule/schedule_success_sheet.dart';
import '../../../viewmodels/schedule_vm.dart';

class AddScheduleScreen extends StatefulWidget {
  final String childId;
  final DateTime selectedDate;

  const AddScheduleScreen({
    super.key,
    required this.childId,
    required this.selectedDate,
  });

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  SchedulePeriod? _period;

  bool get _hasChanged =>
      _titleCtrl.text.isNotEmpty ||
      _descCtrl.text.isNotEmpty ||
      _startTime != null ||
      _endTime != null ||
      _period != null;

  bool get _isValid {
    if (_titleCtrl.text.trim().isEmpty) return false;
    if (_titleCtrl.text.length > 50) return false;
    if (_startTime == null || _endTime == null) return false;
    if (_period == null) return false;

    final start = _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;
    return end > start;
  }

  Future<bool> _onBack() async {
    if (!_hasChanged) return true;

    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Chưa lưu'),
            content: const Text('Bạn chưa lưu, bạn có chắc muốn thoát?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Ở lại'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Thoát'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onBack,
      child: Container(
        height: 622,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _input(
                        controller: _titleCtrl,
                        hint: 'Tên lịch trình',
                        maxLength: 50,
                        onChanged: (_) => setState(() {}),
                      ),
                      _counter(),
                      const SizedBox(height: 16),
                      _input(controller: _descCtrl, hint: 'Mô tả', maxLines: 3),
                      const SizedBox(height: 16),
                      _dateField(),
                      const SizedBox(height: 16),
                      _timeRow(),
                      const SizedBox(height: 24),
                      _periodRow(),
                    ],
                  ),
                ),
              ),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (await _onBack()) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const Text(
            'Thêm lịch trình',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F6F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        counterText: "",
      ),
    );
  }

  Widget _counter() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '${_titleCtrl.text.length}/50',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget _dateField() {
    return _readonlyField(
      hint: 'Ngày',
      value: DateFormat('dd/MM/yyyy').format(widget.selectedDate),
    );
  }

  bool get _isTimeInvalid {
    if (_startTime == null || _endTime == null) return false;

    final start = _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;

    return end <= start;
  }

  Widget _timeRow() {
    return Row(
      children: [
        Expanded(
          child: _timePicker(
            label: 'Giờ bắt đầu',
            time: _startTime,
            onPick: (t) => setState(() => _startTime = t),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _timePicker(
            label: 'Giờ kết thúc',
            time: _endTime,
            errorText: _isTimeInvalid ? 'Giờ kết thúc phải lớn hơn' : null,
            onPick: (t) => setState(() => _endTime = t),
          ),
        ),
      ],
    );
  }

  Widget _timePicker({
    required String label,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onPick,
    String? errorText,
  }) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: time == null ? '' : time.format(context),
      ),
      onTap: () async {
        final t = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (t != null) onPick(t);
      },
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: const Color(0xFFF5F6F8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3F7CFF)),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _readonlyField({
    required String hint,
    required String value,
    VoidCallback? onTap,
  }) {
    final isEmpty = value.isEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            isEmpty ? hint : value,
            style: TextStyle(
              fontSize: 14,
              color: isEmpty ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _periodRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: SchedulePeriod.values.map((p) {
            final selected = _period == p;

            final config = _periodStyle(p);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedScale(
                  scale: selected ? 1.0 : 0.97,
                  duration: const Duration(milliseconds: 120),
                  child: GestureDetector(
                    onTap: () => setState(() => _period = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected
                            ? config.selectedBg
                            : const Color(0xFFF2F3F5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: config.dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            periodToString(p),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: selected
                                  ? config.dotColor
                                  : const Color(0xFF2A2A2A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 14),

        GestureDetector(
          onTap: () {
            // TODO: xử lý thêm
          },
          child: const Text(
            '+ Thêm',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF3F7CFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    final vm = context.read<ScheduleViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isValid
              ? () async {
                  final vm = context.read<ScheduleViewModel>();

                  /// 1️⃣ Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    final startAt = DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                      _startTime!.hour,
                      _startTime!.minute,
                    );

                    final endAt = DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                      _endTime!.hour,
                      _endTime!.minute,
                    );

                    final normalizedDate = DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                    );

                    final schedule = Schedule(
                      id: '',
                      childId: widget.childId,
                      parentUid: vm.parentUid,
                      title: _titleCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      date: normalizedDate,
                      startAt: startAt,
                      endAt: endAt,
                      period: _period!,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await vm.addSchedule(schedule);

                    /// 2️⃣ Hide loading
                    if (mounted) Navigator.pop(context);

                    /// 3️⃣ Reload list
                    await vm.loadMonth();

                    /// 4️⃣ Show success popup (ROOT NAVIGATOR)
                    if (!mounted) return;

                    await showGeneralDialog(
                      context: context,
                      useRootNavigator: true,
                      barrierDismissible: false,
                      barrierLabel: "Success",
                      barrierColor: Colors.black.withOpacity(0.4),
                      transitionDuration: const Duration(milliseconds: 250),
                      pageBuilder: (_, __, ___) {
                        return const Center(
                          child: ScheduleSuccessSheet(
                            message: "Bạn đã thêm một lịch trình mới",
                          ),
                        );
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

                    /// 5️⃣ Sau khi popup đóng → đóng AddScheduleSheet
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) Navigator.pop(context); // đóng loading

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Có lỗi xảy ra")),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F7CFF),
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: const Text(
            'Tạo lịch trình',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF3F7CFF),
            ),
          ),
        );
      },
    );
  }

  _PeriodStyle _periodStyle(SchedulePeriod p) {
    switch (p) {
      case SchedulePeriod.morning:
        return const _PeriodStyle(
          dotColor: Color(0xFF7B61FF),
          selectedBg: Color(0x1A7B61FF),
        );
      case SchedulePeriod.afternoon:
        return const _PeriodStyle(
          dotColor: Color(0xFF00B894),
          selectedBg: Color(0x1A00B894),
        );
      case SchedulePeriod.evening:
        return const _PeriodStyle(
          dotColor: Color(0xFF3F7CFF),
          selectedBg: Color(0x1A3F7CFF),
        );
    }
  }
}

class _PeriodStyle {
  final Color dotColor;
  final Color selectedBg;

  const _PeriodStyle({required this.dotColor, required this.selectedBg});
}

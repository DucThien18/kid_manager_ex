import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/schedule.dart';
import '../../../viewmodels/schedule_vm.dart';
import '../../parent/schedule/schedule_success_sheet.dart';
import '../../../utils/schedule_utils.dart';



class EditScheduleScreen extends StatefulWidget {
  final Schedule schedule;

  const EditScheduleScreen({super.key, required this.schedule});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  SchedulePeriod? _period;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.schedule.title);
    _descCtrl = TextEditingController(text: widget.schedule.description);

    _startTime = TimeOfDay.fromDateTime(widget.schedule.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.schedule.endAt);
    _period = widget.schedule.period;
  }

  bool get _hasChanged =>
      _titleCtrl.text != widget.schedule.title ||
      _descCtrl.text != widget.schedule.description ||
      _startTime != TimeOfDay.fromDateTime(widget.schedule.startAt) ||
      _endTime != TimeOfDay.fromDateTime(widget.schedule.endAt) ||
      _period != widget.schedule.period;

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
                        label: 'Tên lịch trình',
                        maxLength: 50,
                        onChanged: (_) => setState(() {}),
                      ),
                      _counter(),
                      const SizedBox(height: 16),
                      _input(
                        controller: _descCtrl,
                        label: 'Mô tả',
                        maxLines: 3,
                      ),
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
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ),
          const Text(
            'Chỉnh sửa lịch trình',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
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
                /// 1️⃣ Show loading
                showLoadingDialog(context);

                try {
                  final startAt = DateTime(
                    widget.schedule.date.year,
                    widget.schedule.date.month,
                    widget.schedule.date.day,
                    _startTime!.hour,
                    _startTime!.minute,
                  );

                  final endAt = DateTime(
                    widget.schedule.date.year,
                    widget.schedule.date.month,
                    widget.schedule.date.day,
                    _endTime!.hour,
                    _endTime!.minute,
                  );

                  final updatedSchedule = widget.schedule.copyWith(
                    title: _titleCtrl.text.trim(),
                    description: _descCtrl.text.trim(),
                    startAt: startAt,
                    endAt: endAt,
                    period: _period!,
                    updatedAt: DateTime.now(),
                  );

                  /// 2️⃣ Update
                  await vm.updateSchedule(updatedSchedule);

                  /// 3️⃣ Hide loading
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }

                  /// 4️⃣ Reload list
                  await vm.loadMonth();

                  /// 5️⃣ Show success popup
                  if (!mounted) return;

                  await showSuccessPopup(
                    context,
                    message: "Bạn đã sửa thành công",
                  );

                  /// 6️⃣ Close Edit Sheet
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }

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
          'Lưu sự kiện',
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
      return Center(
        child: ScheduleSuccessSheet(
          message: message,
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
}


  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Color(0xFF3F7CFF),
          ),
        ),
      ),
    );
  }

  Widget _input({
  required TextEditingController controller,
  required String label,
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
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto, 
      // auto = có text thì label nổi lên, đúng chuẩn edit

      filled: true,
      fillColor: const Color(0xFFF5F6F8),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF3F7CFF),
          width: 1.2,
        ),
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
    label: 'Ngày',
    value: DateFormat('dd/MM/yyyy').format(widget.schedule.date),
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
          errorText: _isTimeInvalid
              ? 'Giờ kết thúc phải lớn hơn'
              : null,
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
        borderSide: const BorderSide(
          color: Color(0xFF3F7CFF),
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    ),
  );
}


  Widget _readonlyField({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: value),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        filled: true,
        fillColor: const Color(0xFFF5F6F8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF3F7CFF),
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _periodRow() {
    return const SizedBox(); // nếu cần mình sẽ thêm lại giống Add
  }
}

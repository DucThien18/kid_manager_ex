import 'package:flutter/material.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/widgets/common/avatar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/widgets/location/batterIcon.dart';

class ChildInfoSheet extends StatefulWidget {
  final AppUser child;
  final LocationData? latest;
  final bool isSearching;
  final VoidCallback onOpenChat;
  final Future<void> Function(String message) onSendQuickMessage;
  final VoidCallback onToggleSearch;

  const ChildInfoSheet({
    super.key,
    required this.child,
    required this.latest,
    required this.isSearching,
    required this.onOpenChat,
    required this.onSendQuickMessage,
    required this.onToggleSearch,
  });

  @override
  State<ChildInfoSheet> createState() => _ChildInfoSheetState();
}

class _ChildInfoSheetState extends State<ChildInfoSheet> {
  final TextEditingController _msgCtl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _msgCtl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _msgCtl.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      await widget.onSendQuickMessage(text);
      _msgCtl.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi tin nhắn')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gửi thất bại: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  // ✅ Hàm lấy màu gradient theo % pin
  List<Color> _getBatteryGradient(int batteryLevel) {
    if (batteryLevel > 50) {
      return [const Color(0xFF4ADE80), const Color(0xFF16A34A)]; // green
    } else if (batteryLevel > 20) {
      return [const Color(0xFFFB923C), const Color(0xFFEA580C)]; // orange
    } else {
      return [const Color(0xFFEF4444), const Color(0xFFDC2626)]; // red
    }
  }

  // ✅ Hàm lấy icon theo % pin
  IconData _getBatteryIcon(int batteryLevel) {
    if (batteryLevel > 80) return Icons.battery_full;
    if (batteryLevel > 60) return Icons.battery_6_bar;
    if (batteryLevel > 40) return Icons.battery_4_bar;
    if (batteryLevel > 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  // ✅ Hàm lấy màu shadow
  Color _getBatteryShadowColor(int batteryLevel) {
    if (batteryLevel > 50) return const Color(0xFF16A34A);
    if (batteryLevel > 20) return const Color(0xFFEA580C);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final latest = widget.latest;

    final name = child.displayName!.isNotEmpty ? child.displayName : child.email;
    final initial = name!.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    final  double circularBorder =49;
    // ✅ TODO: thay bằng dữ liệu thật từ widget.child hoặc widget.latest
    const int batteryLevel = 20; // thử thay 90, 45, 15 để thấy màu thay đổi
    const statusText = 'Đang học';

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Thông tin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.1,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ===== card user =====
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            AppAvatar(user: child, size: 66),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Online',
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: widget.onOpenChat,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/message.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ===== quick message =====
                      Container(
                        width: 350,
                        height: 49,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              controller: _msgCtl,
                              decoration: const InputDecoration(
                                hintText: 'Gửi tin nhắn nhanh...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.fromLTRB(12, 14, 44, 14),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF303336),
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _send(),
                            ),
                            Positioned(
                              right: 10,
                              top: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: _sending ? null : _send,
                                borderRadius: BorderRadius.circular(8),
                                child: Center(
                                  child: _sending
                                      ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : SvgPicture.asset(
                                    "assets/icons/send-message.svg",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT schedule
                          Expanded(
                            flex:1,
                            child: Container(

                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFDADADA),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFDADADA),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.calendar_month, size: 16),
                                        SizedBox(width: 6),
                                        Text(
                                          'Lịch trình',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const _ScheduleItemStyled(
                                    title: 'Đang học thể dục',
                                    time: '7h00p – 7h45p',
                                  ),
                                  const SizedBox(height: 10),
                                  const _ScheduleItemStyled(
                                    title: 'Đang học toán',
                                    time: '8h00p – 8h45p',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // RIGHT buttons
                          Expanded(
                          flex:1,
                            child: Column(
                              children: [
                                // BATTERY PILL MỚI - gradient + shadow


                                // Thay thế widget battery pill bằng code này:

                                InkWell(
                                onTap: () {},
                            borderRadius: BorderRadius.circular(circularBorder),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.all(1), // khoảng cách cho border
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300, // border màu xám
                                borderRadius: BorderRadius.circular(circularBorder),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getBatteryShadowColor(batteryLevel).withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // nền trắng bên trong
                                  borderRadius: BorderRadius.circular(circularBorder),
                                ),
                                child: Stack(
                                  children: [
                                    // Phần pin còn lại (bên Trái) - có màu
                                    Positioned.fill(
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 800),
                                        curve: Curves.easeInOutCubic,
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: batteryLevel / 100, // % còn lại
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: _getBatteryGradient(batteryLevel),
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(circularBorder),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //Shimmer effect chỉ chạy trên phần có màu
                                    Positioned.fill(
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 800),
                                        curve: Curves.easeInOutCubic,
                                        alignment: Alignment.centerRight,
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerRight,
                                          widthFactor: batteryLevel / 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(circularBorder),
                                            child: TweenAnimationBuilder<double>(
                                              tween: Tween(begin: -1.0, end: 1.0),
                                              duration: const Duration(seconds: 2),
                                              curve: Curves.easeInOut,
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(value * 100, 0),
                                                  child: Container(
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.white.withOpacity(0),
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onEnd: () {
                                                if (mounted) setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),


                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 300),
                                            transitionBuilder: (child, animation) {
                                              return ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              );
                                            },
                                            child:  BatteryIcon(
                                              level: batteryLevel,
                                              color: batteryLevel > 30
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          TweenAnimationBuilder<int>(
                                            tween: IntTween(begin: 0, end: batteryLevel),
                                            duration: const Duration(milliseconds: 800),
                                            curve: Curves.easeOutCubic,
                                            builder: (context, value, child) {
                                              return Text(
                                                '$value%',
                                                style: TextStyle(
                                                  color: batteryLevel > 30 ? Colors.white : Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  shadows: batteryLevel > 30 ? [
                                                    const Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 2,
                                                      color: Colors.black26,
                                                    ),
                                                  ] : null,
                                                ),
                                              );
                                            },
                                          ),




                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                                const SizedBox(height: 10),

                                _RightPill(
                                  icon:SvgPicture.asset(
                                    "assets/icons/status.svg",
                                    fit: BoxFit.contain,
                                  ),
                                  label: statusText,
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                _RightPill(
                                  icon: SvgPicture.asset(
                                    "assets/icons/gps.svg",
                                    fit: BoxFit.contain,
                                  ),
                                  label: widget.isSearching ? 'Tắt tìm kiếm' : 'Tìm kiếm',
                                  onTap: widget.onToggleSearch,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (latest != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Lat ${latest.latitude.toStringAsFixed(4)} • Lng ${latest.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleItemStyled extends StatelessWidget {
  final String title;
  final String time;

  const _ScheduleItemStyled({
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RightPill extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  final Color backgroundColor;
  final Color foregroundColor;

  static const double circularBorder = 49;

  const _RightPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = const Color(0xFF2563EB), // nền xanh
    this.foregroundColor = Colors.white,            // chữ + icon trắng
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(circularBorder),
      child: Container(
        width: 156,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(circularBorder),
          border: Border.all(
            color: backgroundColor, // viền cùng màu nền
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: foregroundColor,
                size: 18,
              ),
              child: icon,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins'
              ),
            ),
          ],
        ),
      ),
    );
  }
}


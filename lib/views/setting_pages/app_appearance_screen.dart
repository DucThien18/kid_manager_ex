import 'package:flutter/material.dart';
import 'package:kid_manager/core/app_colors.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/app/app_icon.dart';
import 'package:kid_manager/widgets/app/app_overlay_sheet.dart';

enum AppLanguageMode { en, vn, cn }

enum AppThemeMode { system, light, dark }

class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: AppIcon(
                        path: "assets/icons/back.svg",
                        type: AppIconType.svg,
                        size: 16,
                      ),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Giao diện ứng dụng",
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Spacer để title center thật
                  const SizedBox(width: 44),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== CONTENT =====
            Column(
              children: [
                InkWell(
                  onTap: () async {
                    final result = await showModalBottomSheet<AppThemeMode>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => ChangeOptionSheet<AppThemeMode>(
                        title: 'Chọn Theme',
                        initialValue: AppThemeMode.system,
                        options: const [
                          OptionItem('Theo hệ thống', AppThemeMode.system),
                          OptionItem('Sáng', AppThemeMode.light),
                          OptionItem('Tối', AppThemeMode.dark),
                        ],
                        onConfirm: (_) {}, // không cần dùng nữa
                      ),
                    );

                    if (result != null) {
                      debugPrint('Theme chọn: $result');
                      // TODO: setState / Provider / save prefs
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Theme',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.38,
                            letterSpacing: -0.41,
                          ),
                        ),

                        Spacer(),

                        Text(
                          'Sáng',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                            letterSpacing: -0.41,
                          ),
                        ),

                        SizedBox(width: 6),

                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1),
                InkWell(
                  onTap: () async {
                    final result = await showModalBottomSheet<AppThemeMode>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => ChangeOptionSheet<AppLanguageMode>(
                        title: 'Chọn ngôn ngữ',
                        initialValue: AppLanguageMode.en,
                        options: const [
                          OptionItem('English', AppLanguageMode.en),
                          OptionItem('Tiếng Việt', AppLanguageMode.vn),
                          OptionItem('中文', AppLanguageMode.cn),
                        ],
                        onConfirm: (lang) {
                          debugPrint('Language chọn: $lang');
                        },
                      ),
                    );

                    if (result != null) {
                      debugPrint('Theme chọn: $result');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Ngôn ngữ',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.38,
                            letterSpacing: -0.41,
                          ),
                        ),

                        Spacer(),

                        Text(
                          'Tiếng Việt',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                            letterSpacing: -0.41,
                          ),
                        ),

                        SizedBox(width: 6),

                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptionRadioRow<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const OptionRadioRow({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              activeColor: const Color(0xFF3366FF),
            ),

            const SizedBox(width: 6),

            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF212121)
                    : const Color(0xFF4C4C4C),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItem<T> {
  final String label;
  final T value;

  const OptionItem(this.label, this.value);
}

class ChangeOptionSheet<T> extends StatefulWidget {
  final String title;
  final T initialValue;
  final List<OptionItem<T>> options;
  final ValueChanged<T> onConfirm;

  const ChangeOptionSheet({
    super.key,
    required this.title,
    required this.initialValue,
    required this.options,
    required this.onConfirm,
  });

  @override
  State<ChangeOptionSheet<T>> createState() => _ChangeOptionSheetState<T>();
}

class _ChangeOptionSheetState<T> extends State<ChangeOptionSheet<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppOverlaySheet(
      height: 300,
      showHandle: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            ...widget.options.map(
              (e) => OptionRadioRow<T>(
                title: e.label,
                value: e.value,
                groupValue: _selected,
                onChanged: (v) {
                  setState(() => _selected = v);
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  width: 167,
                  height: 50,
                  text: 'Hủy bỏ',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: const Color(0xFFE6F5FF),
                  foregroundColor: const Color(0xFF3A7DFF),
                ),
                AppButton(
                  width: 167,
                  height: 50,
                  text: 'Xác nhận',
                  onPressed: () {
                    widget.onConfirm(_selected);
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

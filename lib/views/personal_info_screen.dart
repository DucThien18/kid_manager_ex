import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/core/app_colors.dart';
import 'package:kid_manager/viewmodels/auth_vm.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/views/auth/login_screen.dart';
import 'package:kid_manager/views/setting_pages/about_app_screen.dart';
import 'package:kid_manager/views/setting_pages/add_account_screen.dart';
import 'package:kid_manager/views/setting_pages/app_appearance_screen.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/app/app_icon.dart';
import 'package:kid_manager/widgets/app/app_overlay_sheet.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool allowLocationTracking = false;
  int _age = 0;

  bool _didBind = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserVm>().loadProfile();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    final vm = context.read<UserVm>();

    final ok = await vm.updateUserInfo(
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      gender: _genderCtrl.text,
      dob: _dobCtrl.text,
      address: _addressCtrl.text,
      allowTracking: allowLocationTracking,
    );

    if (!mounted) return;

    if (ok) {
      debugPrint("Update OK");
      // ví dụ: Navigator.pop(context, true);
    } else {
      debugPrint("Update FAIL: ${vm.error}");
      // show snackbar/dialog nếu muốn
    }
  }

  int calculateAgeFromDateString(String dobString) {
    try {
      final parts = dobString.split('/');
      if (parts.length != 3) return 0;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserVm>();
    if (vm.profile != null && !_didBind) {
      _didBind = true;

      final p = vm.profile!;

      _nameCtrl.text = p.name;
      _phoneCtrl.text = p.phone;
      _genderCtrl.text = p.gender;
      _dobCtrl.text = p.dob;
      _addressCtrl.text = p.address;
      allowLocationTracking = p.allowTracking;

      _age = calculateAgeFromDateString(p.dob);
    }
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => const MoreActionSheet(),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 14,
                          right: 14,
                        ),
                        child: AppIcon(
                          path: "assets/icons/menu.svg",
                          type: AppIconType.svg,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Thông tin cá nhân",
                          style: TextStyle(
                            color: Color(0xFF222B45),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 500,
                  height: 235,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ẢNH (đặt trước để nằm dưới)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 25, // chỉnh vị trí ảnh (nằm trên card)
                        child: Image.asset(
                          "assets/images/cover.png",
                          width: 120,
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 350,
                          height: 82,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(78.5),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFF5EC8F2),
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/u1.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      vm.profile?.name ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF212121),
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.11,
                                        letterSpacing: -0.24,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "$_age tuổi",
                                      style: TextStyle(
                                        color: Color(0xFF212121),
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.69,
                                        letterSpacing: -0.41,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: _updateUserInfo,
                                child: Image.asset(
                                  "assets/images/source_edit.png",
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Label
                AppLabeledTextField(
                  label: "Họ và tên",
                  hint: "Nhập họ và tên",
                  controller: _nameCtrl,
                ),
                // Label
                AppLabeledTextField(
                  label: "Số điện thoại",
                  hint: "+84 012345678",
                  controller: _phoneCtrl,
                ),
                // Label
                AppLabeledTextField(
                  label: "Giới tính",
                  hint: "Nam",
                  controller: _genderCtrl,
                ),

                AppLabeledTextField(
                  label: "Ngày sinh",
                  hint: "12/12/2003",
                  controller: _dobCtrl,
                ),

                AppLabeledTextField(
                  label: "Địa chỉ",
                  hint: "Xã Điềm Thụy, Tỉnh Thái Nguyên",
                  controller: _addressCtrl,
                ),

                AppLabeledCheckbox(
                  label: "Quyền theo dõi",
                  text: "Cho phép đối phương theo dõi vị trí",
                  value: allowLocationTracking,
                  onChanged: (v) => setState(() => allowLocationTracking = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final double? width;
  final TextEditingController controller;

  const AppLabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 55,
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF8F9BB3),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFEEEFF1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFEEEFF1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppLabeledCheckbox extends StatelessWidget {
  final String label; // tiêu đề giống input (ở trên)
  final String text; // nội dung cạnh checkbox
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? width;

  const AppLabeledCheckbox({
    super.key,
    required this.label,
    required this.text,
    required this.value,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // "box" đồng bộ với input
          InkWell(
            onTap: () => onChanged(!value),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Row(
              children: [
                Transform.translate(
                  offset: const Offset(-4, 0), // 👈 chỉnh -2, -4, -6 tùy ý
                  child: Checkbox(
                    value: value,
                    onChanged: (v) => onChanged(v ?? false),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: Color(0xFFEEEFF1)),
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- SHEET ----------------
class MoreActionSheet extends StatelessWidget {
  const MoreActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppOverlaySheet(
      height: 240,
      showHandle: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),

            SettingItem(
              title: "Giao diện ứng dụng",
              iconPath: "assets/icons/color_palette.svg",
              iconType: AppIconType.svg,
              iconSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppAppearanceScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            SettingItem(
              title: "About app",
              iconPath: "assets/icons/info.png",
              iconType: AppIconType.png,
              iconSize: 17,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            SettingItem(
              title: "Thêm tài khoản",
              iconPath: "assets/icons/account.png",
              iconType: AppIconType.png,
              iconSize: 18,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAccountScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            SettingItem(
              title: "Đăng xuất",
              iconPath: "assets/icons/log_out.png",
              iconType: AppIconType.png,
              iconSize: 17,
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 100), () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const ConfirmLogoutSheet(),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmLogoutSheet extends StatelessWidget {
  const ConfirmLogoutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      final authVM = context.read<AuthVM>();
      await authVM.logout();
      // if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }

    return AppOverlaySheet(
      height: 220,
      showHandle: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Container(
              width: 345,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFEDF1F7),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              'Bạn muốn đăng xuất?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.38,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    width: 167,
                    height: 50,
                    text: 'Hủy bỏ',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: const Color(0xFFE6F5FF),
                    foregroundColor: const Color(0xFF3A7DFF),
                  ),
                  AppButton(
                    width: 167,
                    height: 50,
                    text: 'Xác nhận',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    onPressed: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 150));
                      await _logout();
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final AppIconType iconType;
  final double iconSize;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.iconType,
    required this.onTap,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            AppIcon(path: iconPath, type: iconType, size: iconSize),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: -0.41,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

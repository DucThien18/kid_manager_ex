import 'package:flutter/material.dart';

import 'package:kid_manager/core/storage_keys.dart';
import 'package:kid_manager/services/storage_service.dart';
import 'package:kid_manager/utils/date_format.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/views/personal_info_screen.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:provider/provider.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _dobCtrl = TextEditingController(); // ngày sinh (readonly)
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  late final String languageCode = locale.languageCode; // vi
  late final String? countryCode = locale.countryCode; // VN

  late final String localeString =
  countryCode == null ? languageCode : '${languageCode}_$countryCode';

// timezone chuẩn (Asia/Ho_Chi_Minh)
  final String timezone =
  DateTime.now().timeZoneName.isNotEmpty
      ? DateTime.now().timeZoneName
      : 'Asia/Ho_Chi_Minh';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  void _onAddAccount() async {
    final dob = parseDateFromText(_dobCtrl.text);

    if (dob == null || !isChildAgeValid(dob)) {
      debugPrint('ChildADD: Ngày sinh không hợp lệ');
      return;
    }

    final userVM = context.read<UserVm>();
    final storage = context.read<StorageService>();

    final parentUid = storage.getString(StorageKeys.uid);
    if (parentUid == null) {
      debugPrint('ChildADD: Chưa đăng nhập phụ huynh');
      return;
    }

    final success = await userVM.createChildAccount(
      parentUid: parentUid,
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      displayName: _nameCtrl.text.trim(),
      dob: dob,
      locale: localeString,
      timezone: timezone,
    );

    debugPrint('ChildADD: Tạo tài khoản cho con thành công');
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm tài khoản con')),
      backgroundColor: const Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(17),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppLabeledTextField(
                label: "Họ và tên",
                hint: "Nhập họ và tên",
                controller: _nameCtrl,
              ),

              const SizedBox(height: 16),

              AppLabeledTextField(
                label: "Email",
                hint: "Nhập email",
                controller: _emailCtrl,
              ),

              const SizedBox(height: 16),

              AppLabeledTextField(
                label: "Mật khẩu",
                hint: "Nhập mật khẩu",
                controller: _passwordCtrl,
              ),

              const SizedBox(height: 16),

              AppLabeledTextField(
                label: "Ngày sinh",
                hint: "Chọn ngày sinh",
                controller: _dobCtrl,
              ),

              const SizedBox(height: 24),

              AppButton(
                text: "Thêm tài khoản",
                height: 50,
                onPressed: _onAddAccount,
              ),

              // đệm dưới để không bị bàn phím che
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

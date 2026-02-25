
import 'package:flutter/material.dart';
import 'package:kid_manager/views/parent/schedule/schedule_success_sheet.dart';

Future<void> showScheduleSuccess(
  BuildContext context,
  String message,
) async {
  await showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (_) => ScheduleSuccessSheet(
      message: message,
    ),
  );
}

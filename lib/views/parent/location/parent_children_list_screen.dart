import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_manager/viewmodels/location/parent_location_vm.dart';
import 'package:kid_manager/viewmodels/user_vm.dart';
import 'package:kid_manager/widgets/location/parent_child_list_item.dart';
import 'package:provider/provider.dart';

class ParentChildrenListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserVm>();
    final children = vm.children;
    final locationVm = context.watch<ParentLocationVm>();

    debugPrint("Children count: ${children.length}");

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách thành viên')),
      backgroundColor: const Color(0xFFF6F7FB),
      body: ListView.builder(

        padding: const EdgeInsets.only(top: 8, bottom: 12),
        itemCount: children.length,
        itemBuilder: (_, i) {
          final child = children[i];
          final location = locationVm.childrenLocations[child.uid];

          return ParentChildListItem(
            child: child,
            location: location,
          );
        },
      ),

    );
  }
}


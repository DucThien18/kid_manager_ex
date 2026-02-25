import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomTab {
  final IconData icon;
  final String label;
  final Widget Function() builder;

  BottomTab({
    required this.icon,
    required this.label,
    required this.builder,
  });
}

class BottomTabConfig {
  final String iconAsset;
  final Widget root;

  const BottomTabConfig({
    required this.iconAsset,
    required this.root,
  });
}


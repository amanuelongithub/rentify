import 'package:flutter/material.dart';
import 'package:yegnabet/utils/globals.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: getTheme(context).onPrimary.withValues(alpha: 0.3), thickness: 2);
  }
}

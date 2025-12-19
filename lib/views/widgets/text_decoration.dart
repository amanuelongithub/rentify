import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yegnabet/utils/theme_data.dart';

InputDecoration decorationText(String? hintTxt) {
  return InputDecoration(
    hintText: hintTxt,
    hintStyle: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.6)),
    border: InputBorder.none,
    prefixIcon: Icon(Icons.search, color: AppTheme.secondaryColor, size: 20.sp),
    contentPadding: const EdgeInsets.symmetric(vertical: 14),
  );
}

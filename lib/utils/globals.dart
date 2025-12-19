import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

double kRadius = 10;

// font-family
const String fontFamily = 'Inter';
// font-size
const double sfont = 14;
const double mfont = 16;
const double lfont = 18;
const double xlfont = 20;
const double xxlfont = 24;

// icon size
final double iconSize = 22.sp;

// horizontal space
const double hPadding = 20;


final textStylel = TextStyle(fontSize: lfont.sp, fontWeight: FontWeight.w600, color: Colors.grey[200]);
final textStylelr = TextStyle(fontSize: lfont.sp, fontWeight: FontWeight.w400, color: Colors.grey[200]);
final textStylem = TextStyle(fontSize: mfont.sp, fontWeight: FontWeight.w500, color: Colors.grey[200]);
final textStyles = TextStyle(fontSize: sfont.sp - 1, fontWeight: FontWeight.w400, color: Colors.grey[300]);

LinearGradient gradient(BuildContext context) {
  return LinearGradient(
    colors: [getTheme(context).secondary.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

ColorScheme getTheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

// const storage = FlutterSecureStorage();
const customShadow = [BoxShadow(color: Color.fromARGB(200, 228, 228, 228), blurRadius: 5, offset: Offset(0, 0))];

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

bool isTextNull(String? text) {
  if (text == null || text == '') {
    return true;
  } else {
    return false;
  }
}

String formatNumberWithCommas(String price) {
  try {
    final number = num.tryParse(price.replaceAll(',', '')) ?? 0;
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number);
  } catch (e) {
    return price;
  }
}

int calcDuration(DateTime dateTime) {
  return DateTime.now().difference(dateTime).inDays.abs();
}

String showMDY(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy').format(dateTime);
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

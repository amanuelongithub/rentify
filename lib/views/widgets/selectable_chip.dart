import 'package:flutter/material.dart';
import 'package:yegnabet/utils/theme_data.dart';

Widget selectableChip({required String label, required IconData icon, required bool isSelected}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.transparent, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? AppTheme.primaryColor : AppTheme.secondaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

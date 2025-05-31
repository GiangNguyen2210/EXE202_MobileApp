import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? Colors.orange[100] : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
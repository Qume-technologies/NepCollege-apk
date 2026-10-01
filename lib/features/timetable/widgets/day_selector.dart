import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? theme.colorScheme.primary 
                    : (theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected 
                    ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.hintColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

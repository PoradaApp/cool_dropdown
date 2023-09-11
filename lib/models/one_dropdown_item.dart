import 'package:flutter/material.dart';

class OneDropdownItem<T> {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final Widget? selectedIcon;
  final T value;

  OneDropdownItem({
    required this.label,
    this.isSelected = false,
    this.icon,
    this.selectedIcon,
    required this.value,
  });

  OneDropdownItem<T> copyWith({
    String? label,
    bool? isSelected,
    Widget? icon,
    Widget? selectedIcon,
    T? value,
  }) {
    return OneDropdownItem<T>(
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      value: value ?? this.value,
    );
  }

  @override
  String toString() {
    return 'CoolDropdownItem(label: $label, isSelected: $isSelected, icon: $icon, selectedIcon: $selectedIcon, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OneDropdownItem<T> &&
        other.label == label &&
        other.isSelected == isSelected &&
        other.icon == icon &&
        other.selectedIcon == selectedIcon &&
        other.value == value;
  }

  @override
  int get hashCode {
    return label.hashCode ^ isSelected.hashCode ^ icon.hashCode ^ selectedIcon.hashCode ^ value.hashCode;
  }
}

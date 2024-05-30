import 'package:flutter/material.dart';

class OneDropdownItem<T> {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final Widget? selectedIcon;
  final T value;
  final Function()? onTap;
  final Widget? prefixIcon;
  final Function(BuildContext context)? builder;

  OneDropdownItem({
    required this.label,
    this.isSelected = false,
    this.icon,
    this.selectedIcon,
    required this.value,
    this.prefixIcon,
    this.onTap,
    this.builder,
  });

  OneDropdownItem<T> copyWith({
    String? label,
    bool? isSelected,
    Widget? icon,
    Widget? selectedIcon,
    T? value,
    Function()? onTap,
    Widget? prefixIcon,
    Function(BuildContext context)? builder,
  }) {
    return OneDropdownItem<T>(
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      value: value ?? this.value,
      onTap: onTap ?? this.onTap,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OneDropdownItem<T> &&
        other.label == label &&
        other.isSelected == isSelected &&
        other.icon == icon &&
        other.selectedIcon == selectedIcon &&
        other.value == value &&
        other.onTap == onTap &&
        other.builder == builder &&
        other.prefixIcon == prefixIcon;
  }

  @override
  int get hashCode {
    return label.hashCode ^
        isSelected.hashCode ^
        icon.hashCode ^
        selectedIcon.hashCode ^
        value.hashCode ^
        onTap.hashCode ^
        builder.hashCode ^
        prefixIcon.hashCode;
  }
}

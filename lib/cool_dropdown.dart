library cool_dropdown;

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/widgets/result_widget.dart';
import 'package:flutter/material.dart';

export 'package:cool_dropdown/controllers/dropdown_controller.dart';
export 'package:cool_dropdown/enums/dropdown_align.dart';
export 'package:cool_dropdown/enums/dropdown_triangle_align.dart';
export 'package:cool_dropdown/enums/selected_item_align.dart';
export 'package:cool_dropdown/enums/result_render.dart';
export 'package:cool_dropdown/enums/dropdown_item_render.dart';
export 'package:cool_dropdown/enums/dropdown_animation.dart';
export 'package:cool_dropdown/options/dropdown_triangle_options.dart';
export 'package:cool_dropdown/options/dropdown_item_options.dart';
export 'package:cool_dropdown/options/dropdown_options.dart';
export 'package:cool_dropdown/options/result_options.dart';
export 'package:cool_dropdown/customPaints/arrow_down_painter.dart';

class CoolDropdown<T> extends StatelessWidget {
  final List<CoolDropdownItem<T>> dropdownList;
  final CoolDropdownItem<T>? defaultItem;

  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;
  final DropdownController<T> controller;

  final void Function(T value) onChange;
  final Function(bool)? onOpen;

  final bool isMarquee;

  CoolDropdown({
    Key? key,
    required this.dropdownList,
    this.defaultItem,
    this.resultOptions = const ResultOptions(),
    this.dropdownOptions = const DropdownOptions(),
    this.dropdownItemOptions = const DropdownItemOptions(),
    this.dropdownTriangleOptions = const DropdownTriangleOptions(),
    required this.controller,
    required this.onChange,
    this.onOpen,
    this.isMarquee = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResultWidget<T>(
      dropdownList: dropdownList,
      resultOptions: resultOptions,
      dropdownOptions: dropdownOptions,
      dropdownItemOptions: dropdownItemOptions,
      dropdownArrowOptions: dropdownTriangleOptions,
      controller: controller,
      onChange: onChange,
      onOpen: onOpen,
      defaultItem: defaultItem,
    );
  }
}

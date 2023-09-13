library cool_dropdown;

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/one_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/widgets/result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:cool_dropdown/controllers/dropdown_controller.dart';
export 'package:cool_dropdown/customPaints/arrow_down_painter.dart';
export 'package:cool_dropdown/enums/dropdown_align.dart';
export 'package:cool_dropdown/enums/dropdown_animation.dart';
export 'package:cool_dropdown/enums/dropdown_item_render.dart';
export 'package:cool_dropdown/enums/dropdown_triangle_align.dart';
export 'package:cool_dropdown/enums/result_render.dart';
export 'package:cool_dropdown/enums/selected_item_align.dart';
export 'package:cool_dropdown/options/dropdown_item_options.dart';
export 'package:cool_dropdown/options/dropdown_options.dart';
export 'package:cool_dropdown/options/dropdown_triangle_options.dart';
export 'package:cool_dropdown/options/result_options.dart';

class CoolDropdown<T> extends StatelessWidget {
  final List<OneDropdownItem<T>> dropdownList;
  final OneDropdownItem<T>? defaultItem;
  final OneDropdownItem<T>? undefinedItem;
  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;
  final DropdownController controller;
  final Function(T) onChange;
  final Function()? onClose;
  final Function(bool)? onOpen;
  final bool hasInputField;
  final TextEditingController? textController;
  final bool isMarquee;
  final Function(String value)? onTextEditing;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? inputDecoration;
  final String? hintText;
  final String? Function(String? value)? onValidate;

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
    this.onTextEditing,
    this.onOpen,
    this.isMarquee = false,
    this.hasInputField = false,
    this.inputFormatters,
    this.hintText,
    this.undefinedItem,
    this.inputDecoration,
    this.onValidate,
    this.onClose,
    this.textController,
  }) : super(key: key) {
    assert(!hasInputField || textController != null, 'textController must be provided when hasInputField is true');
  }

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
      hasInputField: hasInputField,
      textController: textController,
      inputFormatters: inputFormatters,
      hintText: hintText,
      undefinedItem: undefinedItem,
      inputDecoration: inputDecoration,
      onValidate: onValidate,
      onClose: onClose ?? () {},
    );
  }
}

import 'dart:math';

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/enums/result_render.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
import 'package:cool_dropdown/widgets/dropdown_widget.dart';
import 'package:cool_dropdown/widgets/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultWidget<T> extends StatefulWidget {
  final List<CoolDropdownItem<T>> dropdownList;
  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownArrowOptions;
  final DropdownController controller;
  final Function(T t) onChange;
  final Function(bool)? onOpen;
  final bool hasInputField;
  final Function(String value)? onEditingChange;
  final List<TextInputFormatter>? inputFormatters;
  final CoolDropdownItem<T>? defaultItem;
  final String? hintText;
  final CoolDropdownItem<T>? undefinedItem;
  final InputDecoration? inputDecoration;
  final String? Function(String? value)? onValidate;

  const ResultWidget({
    Key? key,
    required this.dropdownList,
    required this.resultOptions,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownArrowOptions,
    required this.controller,
    required this.onChange,
    this.hasInputField = false,
    this.onOpen,
    this.defaultItem,
    this.onEditingChange,
    this.inputFormatters,
    this.hintText,
    this.undefinedItem,
    this.inputDecoration,
    this.onValidate,
  }) : super(key: key);

  @override
  State<ResultWidget<T>> createState() => _ResultWidgetState<T>();
}

class _ResultWidgetState<T> extends State<ResultWidget<T>> {
  late final TextEditingController _textController;

  final resultKey = GlobalKey();
  CoolDropdownItem<T>? selectedItem;

  bool _isError = false;

  late final _decorationBoxTween = DecorationTween(
    begin: widget.resultOptions.boxDecoration,
    end: widget.resultOptions.openBoxDecoration,
  ).animate(widget.controller.resultBox);

  @override
  void initState() {
    if (widget.defaultItem != null) {
      _setSelectedItem(widget.defaultItem!);
    }
    if (widget.hasInputField) {
      _textController = TextEditingController();
      if (widget.defaultItem != null) {
        _textController.text = widget.defaultItem!.label;
      }
    }
    widget.controller.setFunctions(onError, widget.onOpen, open, _setSelectedItem);
    widget.controller.setResultOptions(widget.resultOptions);

    super.initState();
  }

  void onError(bool value) {
    setState(() {
      _isError = value;
    });
  }

  void open() {
    widget.controller.show(
        context: context,
        child: DropdownWidget<T>(
          controller: widget.controller,
          dropdownOptions: widget.dropdownOptions,
          dropdownItemOptions: widget.dropdownItemOptions,
          dropdownTriangleOptions: widget.dropdownArrowOptions,
          resultKey: resultKey,
          onChangedText: (value) {
            if (widget.hasInputField) {
              _textController.text = value;
              setState(() {});
            }
          },
          onChange: (value) {
            widget.onChange(value);
          },
          dropdownList: widget.dropdownList,
          selectedItemCallback: (item) => _setSelectedItem(item),
          selectedItem: selectedItem,
          bodyContext: context,
          undefinedItem: widget.undefinedItem,
        ));
  }

  void _setSelectedItem(CoolDropdownItem<T> item) {
    setState(() {
      selectedItem = item;
    });
  }

  Widget _buildArrow() {
    return AnimatedBuilder(
        animation: widget.controller.controller,
        builder: (_, __) {
          return Transform.rotate(
            angle: pi * widget.controller.rotation.value,
            child: widget.resultOptions.icon,
          );
        });
  }

  Widget _buildResultItem() {
    if (widget.resultOptions.render == ResultRender.all ||
        widget.resultOptions.render == ResultRender.label ||
        widget.resultOptions.render == ResultRender.reverse) {
      return _buildMarquee(
        Container(
          child: Text(
            selectedItem?.label ?? widget.resultOptions.placeholder ?? '',
            overflow: widget.resultOptions.textOverflow,
            style: selectedItem != null ? widget.resultOptions.textStyle : widget.resultOptions.placeholderTextStyle,
          ),
        ),
      );
    } else {
      return selectedItem?.icon ?? const SizedBox();
    }
  }

  Widget _buildInputFieldItem() {
    if (widget.resultOptions.render == ResultRender.all ||
        widget.resultOptions.render == ResultRender.label ||
        widget.resultOptions.render == ResultRender.reverse)
      return _buildMarquee(
        Container(
          width: widget.resultOptions.width,
          child: Center(
            child: TextFormField(
              onTap: () {
                _textController.clear();
                setState(() {});
              },
              onChanged: (value) {
                widget.onEditingChange?.call(value);
                if (value.isEmpty) {
                  widget.controller.removeOverlay();
                }
              },
              validator: (value) => widget.onValidate?.call(value),
              inputFormatters: widget.inputFormatters,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: widget.resultOptions.inputTextField,
              cursorColor: widget.resultOptions.inputTextField.color,
              controller: _textController,
              decoration: widget.inputDecoration ??
                  InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: widget.resultOptions.inputTextField,
                  ),
            ),
          ),
        ),
      );
    else {
      return SizedBox();
    }
  }

  Widget _buildMarquee(Widget child) {
    return widget.resultOptions.isMarquee
        ? MarqueeWidget(
            child: child,
          )
        : child;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => open(),
      child: AnimatedBuilder(
          animation: Listenable.merge([widget.controller.controller, widget.controller.errorController]),
          builder: (_, __) {
            return Container(
              width: widget.resultOptions.width,
              child: Stack(
                children: [
                  if (widget.hasInputField) _buildInputFieldItem(),
                  Container(
                    key: resultKey,
                    height: widget.hasInputField ? null : widget.resultOptions.height,
                    decoration: widget.hasInputField
                        ? null
                        : (_isError ? widget.controller.errorDecoration.value : _decorationBoxTween.value),
                    child: Align(
                      alignment: widget.resultOptions.alignment,
                      child: widget.resultOptions.render != ResultRender.none
                          ? Padding(
                              padding: widget.resultOptions.padding,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  children: [
                                    Expanded(
                                      child: AnimatedSwitcher(
                                        duration: widget.resultOptions.duration,
                                        transitionBuilder: (child, animation) {
                                          return SizeTransition(
                                            sizeFactor: animation,
                                            axisAlignment: 1,
                                            child: child,
                                          );
                                        },
                                        child: widget.hasInputField ? Container() : _buildResultItem(),
                                      ),
                                    ),
                                    SizedBox(width: widget.resultOptions.space),
                                    Material(
                                      color: widget.resultOptions.backgroundIconColor ?? Colors.transparent,
                                      borderRadius: widget.resultOptions.iconRadius,
                                      child: ClipRRect(
                                        borderRadius: widget.resultOptions.iconRadius,
                                        child: Container(
                                          height: widget.resultOptions.height,
                                          width: 48,
                                          child: Center(
                                            child: _buildArrow(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].isReverse(widget.resultOptions.render == ResultRender.reverse),
                                ),
                              ),
                            )
                          : _buildArrow(),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

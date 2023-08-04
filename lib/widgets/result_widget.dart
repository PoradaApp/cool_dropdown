import 'dart:math';

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/enums/dropdown_item_render.dart';
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
  }) : super(key: key);

  @override
  State<ResultWidget<T>> createState() => _ResultWidgetState<T>();
}

class _ResultWidgetState<T> extends State<ResultWidget<T>> {
  late final TextEditingController _controller;

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
      _controller = TextEditingController();
      if (widget.defaultItem != null) {
        _controller.text = widget.defaultItem!.label;
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

  void canOpen() {
    if (!widget.hasInputField) {
      open();
    } else {
      //HERE
      open();
    }
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
              _controller.text = value;
              setState(() {});
            }
          },
          onChange: (value) {
            widget.onChange(value);
          },
          dropdownList: widget.dropdownList,
          getSelectedItem: (index) => _setSelectedItem(widget.dropdownList[index]),
          selectedItem: selectedItem,
          bodyContext: context,
          undefinedItem: widget.undefinedItem,
        ));
  }

  void _setSelectedItem(CoolDropdownItem<T>? item) {
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

  List<Widget> _buildResultItem() => [
        /// if you want to show icon in result widget
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.label ||
            widget.resultOptions.render == ResultRender.reverse)
          Flexible(
            child: _buildMarquee(
              Text(
                selectedItem?.label ?? widget.resultOptions.placeholder ?? '',
                overflow: widget.resultOptions.textOverflow,
                style:
                    selectedItem != null ? widget.resultOptions.textStyle : widget.resultOptions.placeholderTextStyle,
              ),
            ),
          ),

        /// if you want to show label in result widget
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.icon ||
            widget.resultOptions.render == ResultRender.reverse)
          selectedItem?.icon ?? const SizedBox(),

        /// if you want to show icon + label in result widget
      ].isReverse(widget.dropdownItemOptions.render == DropdownItemRender.reverse);

  List<Widget> _buildInputFieldItem() => [
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.label ||
            widget.resultOptions.render == ResultRender.reverse)
          Flexible(child: LayoutBuilder(
            builder: (context, constrainst) {
              final width = constrainst.maxWidth;
              return _buildMarquee(
                Container(
                  height: widget.resultOptions.height,
                  width: width,
                  child: Center(
                    child: TextField(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          widget.onEditingChange?.call(value);
                          //canOpen();
                        } else {
                          widget.controller.close();
                        }
                      },
                      /* onEditingComplete: () {
                        widget.controller.close();
                        widget.controller.open();
                      }, */
                      inputFormatters: widget.inputFormatters,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      style: widget.resultOptions.inputTextField,
                      cursorColor: widget.resultOptions.inputTextField.color,
                      controller: _controller,
                      decoration: InputDecoration(
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
            },
          )),

        /// if you want to show label in result widget
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.icon ||
            widget.resultOptions.render == ResultRender.reverse)
          selectedItem?.icon ?? const SizedBox(),

        /// if you want to show icon + label in result widget
      ].isReverse(widget.dropdownItemOptions.render == DropdownItemRender.reverse);

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
      onTap: canOpen,
      child: AnimatedBuilder(
          animation: Listenable.merge([widget.controller.controller, widget.controller.errorController]),
          builder: (_, __) {
            return Container(
              key: resultKey,
              width: widget.resultOptions.width,
              height: widget.resultOptions.height,
              padding: widget.resultOptions.padding,
              decoration: _isError ? widget.controller.errorDecoration.value : _decorationBoxTween.value,
              child: Align(
                alignment: widget.resultOptions.alignment,
                child: widget.resultOptions.render != ResultRender.none
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: widget.resultOptions.duration,
                              transitionBuilder: (child, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -2,
                                  child: child,
                                );
                              },
                              child: Row(
                                key: ValueKey(selectedItem?.label),
                                mainAxisAlignment: widget.resultOptions.mainAxisAlignment,
                                children: widget.hasInputField ? _buildInputFieldItem() : _buildResultItem(),
                              ),
                            ),
                          ),
                          SizedBox(width: widget.resultOptions.space),
                          /* if (_shouldBuildIcon())  */ _buildArrow(),
                        ].isReverse(widget.resultOptions.render == ResultRender.reverse),
                      )
                    : _buildArrow(),
              ),
            );
          }),
    );
  }

  bool _shouldBuildIcon() {
    if (widget.hasInputField) {
      return widget.resultOptions.icon != null;
    } else {
      return widget.resultOptions.icon != null;
    }
  }
}

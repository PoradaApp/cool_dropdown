import 'package:cool_dropdown/controllers/dropdown_calculator.dart';
import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/customPaints/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_animation.dart';
import 'package:cool_dropdown/models/one_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/typedefs/typedef.dart';
import 'package:cool_dropdown/widgets/dropdown_item_widget.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatefulWidget {
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;
  final DropdownController controller;
  final GlobalKey resultKey;
  final BuildContext bodyContext;
  final List<OneDropdownItem<T>> dropdownList;
  final Function(T t) onChange;
  final Function() onClose;
  final TextEditingController? textController;
  final SelectedItemCallback<T> selectedItemCallback;
  final OneDropdownItem<T>? selectedItem;
  final OneDropdownItem<T>? undefinedItem;
  final OneDropdownItem<T>? emptyItem;

  const DropdownWidget({
    Key? key,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownTriangleOptions,
    required this.controller,
    required this.resultKey,
    required this.bodyContext,
    required this.dropdownList,
    required this.onChange,
    required this.selectedItemCallback,
    required this.selectedItem,
    required this.textController,
    required this.undefinedItem,
    required this.onClose,
    required this.emptyItem,
  }) : super(key: key);

  @override
  DropdownWidgetState<T> createState() => DropdownWidgetState<T>();
}

class DropdownWidgetState<T> extends State<DropdownWidget<T>> {
  var dropdownOffset = Offset(0, 0);
  late final DropdownCalculator _dropdownCalculator;

  @override
  void initState() {
    _dropdownCalculator = DropdownCalculator(
      bodyContext: widget.bodyContext,
      resultKey: widget.resultKey,
      dropdownOptions: widget.dropdownOptions,
      dropdownTriangleOptions: widget.dropdownTriangleOptions,
      dropdownItemOptions: widget.dropdownItemOptions,
      dropdownList: widget.dropdownList,
    );
    dropdownOffset = _dropdownCalculator.setOffset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = widget.dropdownList.indexWhere((dropdownItem) => dropdownItem == widget.selectedItem);
      if (currentIndex < 0) return;
      if (widget.selectedItem != null) {
        _setSelectedItem(widget.selectedItem!);
      }
      _dropdownCalculator.setScrollPosition(currentIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    _dropdownCalculator.dispose();
    super.dispose();
  }

  void _setSelectedItem(OneDropdownItem<T> item) {
    widget.selectedItemCallback(item);
  }

  Widget _buildAnimation({required Widget child}) {
    switch (widget.dropdownOptions.animationType) {
      case DropdownAnimationType.size:
        return SizeTransition(
          sizeFactor: widget.controller.showDropdown,
          axisAlignment: -1,
          child: child,
        );
      case DropdownAnimationType.scale:
        return ScaleTransition(
          scale: widget.controller.showDropdown,
          alignment: Alignment(_dropdownCalculator.calcArrowAlignmentDx, _dropdownCalculator.isArrowDown ? 1 : -1),
        );
      case DropdownAnimationType.none:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              widget.onClose();
              widget.controller.close();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: dropdownOffset.dy - widget.dropdownOptions.marginGap.top,
            left: dropdownOffset.dx - widget.dropdownOptions.marginGap.left,
            child: _buildAnimation(
              child: Container(
                margin: widget.dropdownOptions.marginGap,
                clipBehavior: Clip.antiAlias,
                width: _dropdownCalculator.dropdownWidth,
                height: widget.dropdownList.isNotEmpty ? limitToMax(widget.dropdownList.length, 8) * 52 : 52,
                padding: EdgeInsets.all(widget.dropdownOptions.borderSide.width * 0.5),
                decoration: ShapeDecoration(
                  //color: widget.dropdownOptions.color,
                  shadows: widget.dropdownOptions.shadows,
                  shape: DropdownShapeBorder(
                    triangle: widget.dropdownTriangleOptions,
                    radius: widget.dropdownOptions.borderRadius,
                    borderSide: widget.dropdownOptions.borderSide,
                    arrowAlign: widget.dropdownTriangleOptions.align,
                    isTriangleDown: _dropdownCalculator.isArrowDown,
                  ),
                ),
                child: Container(child: _buildItems()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int limitToMax(int number, int max) {
    if (number > max) {
      return max;
    }
    return number;
  }

  Widget _buildItems() {
    if (widget.dropdownList.isNotEmpty) {
      return Material(
        color: widget.dropdownOptions.color,
        borderRadius: widget.dropdownOptions.borderRadius,
        child: ListView.builder(
          controller: _dropdownCalculator.scrollController,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.dropdownList.length,
          itemBuilder: (_, index) => InkWell(
            borderRadius: widget.dropdownOptions.splashRadius,
            highlightColor: widget.dropdownOptions.splashColor,
            focusColor: widget.dropdownOptions.splashColor,
            hoverColor: widget.dropdownOptions.splashColor,
            splashColor: widget.dropdownOptions.splashColor,
            onTap: () {
              if (widget.textController != null) {
                widget.textController!.text = widget.dropdownList[index].label;
              }
              widget.onChange.call(widget.dropdownList[index].value);
              _setSelectedItem(widget.dropdownList[index]);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownItemWidget(
                  item: widget.dropdownList[index],
                  dropdownItemOptions: widget.dropdownItemOptions,
                  decoration: widget.dropdownItemOptions.selectedBoxDecoration,
                  height: widget.dropdownItemOptions.height,
                ),
                if (index != widget.dropdownList.length - 1)
                  SizedBox(
                    height: widget.dropdownOptions.gap.betweenItems,
                  ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.emptyItem != null && widget.textController != null && widget.textController!.text.isEmpty) {
      return Material(
        color: widget.dropdownOptions.color,
        borderRadius: widget.dropdownOptions.borderRadius,
        child: Container(
          child: InkWell(
            borderRadius: widget.dropdownOptions.splashRadius,
            highlightColor: widget.dropdownOptions.splashColor,
            focusColor: widget.dropdownOptions.splashColor,
            hoverColor: widget.dropdownOptions.splashColor,
            splashColor: widget.dropdownOptions.splashColor,
            onTap: () {
              widget.controller.close();
            },
            child: DropdownItemWidget(
              item: widget.emptyItem!,
              dropdownItemOptions: widget.dropdownItemOptions,
              decoration: widget.dropdownOptions.emptyDecoration ?? BoxDecoration(),
              height: 52,
            ),
          ),
        ),
      );
    } else if (widget.undefinedItem != null) {
      return Material(
        color: widget.dropdownOptions.color,
        borderRadius: widget.dropdownOptions.borderRadius,
        child: Container(
          child: InkWell(
            borderRadius: widget.dropdownOptions.splashRadius,
            highlightColor: widget.dropdownOptions.splashColor,
            focusColor: widget.dropdownOptions.splashColor,
            hoverColor: widget.dropdownOptions.splashColor,
            splashColor: widget.dropdownOptions.splashColor,
            onTap: () {
              widget.controller.close();
            },
            child: DropdownItemWidget(
              item: widget.undefinedItem!,
              dropdownItemOptions: widget.dropdownItemOptions,
              decoration: widget.dropdownOptions.undefinedDecoration ?? BoxDecoration(),
              height: 52,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

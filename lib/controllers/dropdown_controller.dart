import 'package:cool_dropdown/models/one_dropdown_item.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/typedefs/typedef.dart';
import 'package:cool_dropdown/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DropdownController<T> implements TickerProvider {
  /// dropdown staggered animation controller
  late final AnimationController _controller;

  /// error animation controller
  late final AnimationController _errorController;

  /// dropdown staggered animation duration
  final Duration duration;

  /// error animation duration
  final Duration errorDuration;

  /// result arrow animation interval
  final Interval resultArrowInterval;

  /// result box animation interval
  final Interval resultBoxInterval;

  /// show dropdown animation interval
  final Interval showDropdownInterval;

  /// show error animation curve
  final Curve showErrorCurve;

  OverlayEntry? _overlayEntry;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void Function(bool value)? _onError;
  void Function(bool value)? get onError => _onError;

  VoidCallback? _openFunction;
  VoidCallback? get openFunction => _openFunction;

  SelectedItemCallback<T>? _setValueFunction;
  SelectedItemCallback<T>? get setValueFunction => _setValueFunction;

  void Function()? _onOpenCallback;

  bool _isError = false;
  bool get isError => _isError;

  ResultOptions _resultOptions = ResultOptions();

  DropdownController({
    this.duration = const Duration(milliseconds: 500),
    this.errorDuration = const Duration(milliseconds: 500),
    this.resultArrowInterval = const Interval(0.0, 0.5, curve: Curves.easeOut),
    this.resultBoxInterval = const Interval(0.0, 0.5, curve: Curves.easeOut),
    this.showDropdownInterval = const Interval(0.5, 1.0, curve: Curves.easeOut),
    this.showErrorCurve = Curves.easeIn,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _errorController = AnimationController(
      vsync: this,
      duration: errorDuration,
    );
  }

  AnimationController get controller => _controller;
  AnimationController get errorController => _errorController;

  Tween<Decoration> errorDecorationTween = DecorationTween(
    begin: BoxDecoration(),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Animation<Decoration> get errorDecoration => errorDecorationTween.animate(_errorController);

  Animation<double> get rotation => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: this.resultArrowInterval,
        ),
      );

  Animation<double> get resultBox => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: this.resultBoxInterval,
        ),
      );

  Animation<double> get showDropdown => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: this.showDropdownInterval,
        ),
      );

  Animation<double> get showError => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _errorController,
          curve: this.showErrorCurve,
        ),
      );

  void show({required BuildContext context, required DropdownWidget child}) {
    if (_overlayEntry != null && Overlay.of(context).mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayEntry = OverlayEntry(builder: (_) => child);
    if (_overlayEntry == null) return;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);

    _isOpen = true;
    _onOpenCallback?.call();
    _controller.forward();
  }

  void open() {
    openFunction!.call();
  }

  void removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void close() async {
    await _controller.reverse();
    removeOverlay();

    _isOpen = false;
  }

  void resetValue() {
    setValueFunction?.call(null);
  }

  void setValue(OneDropdownItem<T>? item) {
    setValueFunction?.call(item);
  }

  Future<void> error() async {
    if (_isError) return;
    _setErrorDecorationTween(_resultOptions.boxDecoration, _resultOptions.errorBoxDecoration);
    _onError?.call(true);
    _isError = true;
    _errorController.reset();
    await _errorController.forward();
  }

  Future<void> resetError() async {
    _setErrorDecorationTween(
        errorDecorationTween.end!, _isOpen ? _resultOptions.openBoxDecoration : _resultOptions.boxDecoration);
    _errorController.reset();
    await _errorController.forward();
    _onError?.call(false);
    _isError = false;
  }

  void setFunctions({
    required void Function(bool value) errorFunction,
    required void Function()? onOpenCallback,
    required SelectedItemCallback<T> setItemFunction,
    required Function() openFunction,
  }) {
    _onError = errorFunction;
    _onOpenCallback = onOpenCallback;
    _setValueFunction = setItemFunction;
    _openFunction = openFunction;
  }

  void setResultOptions(ResultOptions resultOptions) {
    _resultOptions = resultOptions;
  }

  void _setErrorDecorationTween(Decoration begin, Decoration end) {
    errorDecorationTween.begin = begin;
    errorDecorationTween.end = end;
  }

  void dispose() {
    _controller.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'DropdownController');
  }
}

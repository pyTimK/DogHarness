import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class MyDrowpdown<T> extends StatefulWidget {
  const MyDrowpdown({
    required this.controller,
    required this.items,
    required this.hint,
    required this.label,
    required this.validator,
    this.onChanged,
    super.key,
  });
  final MyDropdownController<T> controller;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final String label;
  final String? Function(T? value) validator;
  final ValueChanged<T?>? onChanged;

  @override
  State<MyDrowpdown<T>> createState() => _MyDrowpdownState();
}

class _MyDrowpdownState<T> extends State<MyDrowpdown<T>> {
  T? _value;

  _setValue(T? value) {
    widget.onChanged?.call(value);
    if (value != null) {
      widget.controller.value = value;
      setState(() {
        _value = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items,
      onChanged: _setValue,
      value: _value,
      isExpanded: true,
      hint: Text(widget.hint, style: MyStyles.h2),
      borderRadius: BorderRadius.circular(10),
      decoration: MyStyles.myInputDecoration(_value != null ? widget.label : ""),
      elevation: 3,
      dropdownColor: MyStyles.white,
      validator: widget.validator,
    );
  }
}

class MyDropdownController<T> {
  MyDropdownController();
  T? value;
}

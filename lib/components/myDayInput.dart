import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyDayInput extends StatefulWidget {
  const MyDayInput(
      {this.controller, required this.validator, required this.label, this.initialValue, this.onChanged, super.key});
  final MyDayInputController? controller;
  final FormFieldValidator<DateTime> validator;
  final String label;
  final DateTime? initialValue;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<MyDayInput> createState() => _MyDayInputState();
}

class _MyDayInputState extends State<MyDayInput> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  _showDatePicker(FormFieldState<DateTime> field) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        widget.controller?.value = value;
        widget.onChanged?.call(value);
        field.didChange(value);
        setState(() {
          _value = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildContainer(field),
                if (_value != null) _buildLabel(context),
              ],
            ),
            if (field.hasError) _buildErrorText(field.errorText!, context),
          ],
        );
      },
    );
  }

  Widget _buildContainer(FormFieldState<DateTime> field) {
    return GestureDetector(
      onTap: () => _showDatePicker(field),
      child: Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: !field.hasError ? MyStyles.dark : MyStyles.red),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _value == null
                  ? Text(widget.label, style: MyStyles.h2.colour(MyStyles.dark60))
                  : Text(getFormattedDate(_value!), style: MyStyles.h2),
              SvgPicture.asset(
                "assets/svg/calendar.svg",
              ),
            ],
          )),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Positioned(
      top: -8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(widget.label, style: MyStyles.myInputDecoration("").labelStyle!.copyWith(fontSize: 12)),
      ),
    );
  }

  Widget _buildErrorText(String errorText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12),
      child: Text(
        errorText,
        style: MyStyles.myInputDecoration("").errorStyle,
      ),
    );
  }
}

class MyDayInputController {
  MyDayInputController();
  DateTime? value;
}

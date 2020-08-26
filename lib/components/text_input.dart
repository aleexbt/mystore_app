import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mystore/constants.dart';

class TextInput extends StatelessWidget {
  final bool enabled;
  final bool isRequired;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;
  final int maxLength;
  final String hintText;
  final String validatorText;
  final Function onSubmitted;
  final FocusNode focusNode;
  final bool obscureText;
  final Widget suffixIcon;

  const TextInput({
    Key key,
    this.enabled = true,
    this.isRequired = true,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.hintText,
    this.validatorText,
    this.onSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters ?? null,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: ThemeMode.system == ThemeMode.light
            ? Colors.grey[200]
            : Colors.grey[200],
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        errorStyle: TextStyle(height: 0),
        counterText: '',
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
        ),
      ),
      style: TextStyle(
        fontSize: 14.0,
      ),
      validator: isRequired
          ? (text) {
              if (text.isEmpty) {
                return '';
              } else {
                return null;
              }
            }
          : null,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode ?? null,
      obscureText: obscureText,
    );
  }
}

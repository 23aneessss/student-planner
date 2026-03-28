// lib/core/widgets/planora_input.dart
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

class PlanoraTextField extends StatelessWidget {
  const PlanoraTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: obscure ? 1 : maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: kDark, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class PlanoraDropdown<T> extends StatelessWidget {
  const PlanoraDropdown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  });

  final String? label;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, hintText: hint),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.white,
      validator: validator,
      items: items,
      onChanged: onChanged,
      style: const TextStyle(color: kDark, fontSize: 16),
    );
  }
}

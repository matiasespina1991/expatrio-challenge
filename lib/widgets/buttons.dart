import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ExpatrioButton({
  required String text,
  required VoidCallback onPressed,
  bool isPrimary = true,
  bool isDisabled = false,
  bool fullWidth = false,
}) {
  return ElevatedButton(
    onPressed: isDisabled ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isPrimary
          ? const Color(0xFF40AF9E)
          : const Color(0xFFE0E0E0).withOpacity(0.5),
      minimumSize:
          fullWidth ? const Size(double.infinity, 50) : const Size(130, 50),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: isDisabled ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
        fontFamily: 'Acumin Pro',
      ),
    ),
  );
}

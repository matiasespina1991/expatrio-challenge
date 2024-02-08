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
      minimumSize:
          fullWidth ? const Size(double.infinity, 50) : const Size(200, 50),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: isPrimary ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
        fontFamily: 'Acumin Pro',
      ),
    ),
  );
}

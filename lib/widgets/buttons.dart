import 'package:flutter/material.dart';

class ExpatrioButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final bool fullWidth;

  const ExpatrioButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isDisabled = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary && !isDisabled
            ? const Color(0xFF40AF9E)
            : isDisabled
                ? const Color(0xFFE0E0E0)
                : Colors.grey,
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
}

class ExpatrioTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double fontSize;
  final bool isDisabled;
  final bool fullWidth;

  const ExpatrioTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 15,
    this.isPrimary = true,
    this.isDisabled = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? () {} : onPressed,
      style: TextButton.styleFrom(
        minimumSize:
            fullWidth ? const Size(double.infinity, 50) : const Size(0, 0),
        padding: const EdgeInsets.all(0),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDisabled ? Colors.grey : const Color(0xFF40AF9E),
          fontFamily: 'Acumin Pro',
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

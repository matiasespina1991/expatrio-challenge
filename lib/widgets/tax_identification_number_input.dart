import 'package:flutter/material.dart';

class TaxIdentificationNumberInput extends StatelessWidget {
  final TextEditingController taxIdController;
  final bool taxIdFieldHasError;
  final Function(String) onValueChanged;

  const TaxIdentificationNumberInput({
    super.key,
    required this.taxIdController,
    required this.taxIdFieldHasError,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tax identification number*'.toUpperCase(),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: taxIdController,
          keyboardType: TextInputType.number,
          onChanged: onValueChanged,
          decoration: InputDecoration(
            errorText: taxIdFieldHasError
                ? 'Please enter a valid tax identification number.'
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            hintStyle: const TextStyle(fontSize: 14),
            hintText: 'Tax ID or N/A',
          ),
        ),
      ],
    );
  }
}

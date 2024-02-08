import 'package:flutter/material.dart';

import 'buttons.dart';

class TaxDataModalContent extends StatefulWidget {
  final VoidCallback onTapConfirm;

  const TaxDataModalContent({super.key, required this.onTapConfirm});

  @override
  TaxDataModalContentState createState() => TaxDataModalContentState();
}

class TaxDataModalContentState extends State<TaxDataModalContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Declaration of financial information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 100),
              ExpatrioButton(
                onPressed: () {
                  widget.onTapConfirm();
                },
                text: 'Got it',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

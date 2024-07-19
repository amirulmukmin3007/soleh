import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soleh/themes/fonts.dart';

class RadiusPopupInput extends StatefulWidget {
  const RadiusPopupInput({
    super.key,
    required this.radiusTypeList,
    required this.selectedRadiusType,
    required this.radiusController,
    required this.widget,
    required this.onPressed,
    required this.reset,
    required this.radiusFlag,
  });

  final List<String> radiusTypeList;
  final String selectedRadiusType;
  final TextEditingController radiusController;
  final Widget widget;
  final void Function() onPressed;
  final void Function() reset;
  final bool radiusFlag;

  @override
  State<RadiusPopupInput> createState() => _RadiusPopupInputState();
}

class _RadiusPopupInputState extends State<RadiusPopupInput> {
  @override
  Widget build(BuildContext context) {
    FontTheme fontTheme = FontTheme();
    return AlertDialog(
      title: Text(
        'Choose your radius',
        style: TextStyle(
          fontFamily: fontTheme.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please enter radius in either metres or kilometres.',
            style: TextStyle(
              fontFamily: fontTheme.fontFamily,
              fontSize: 12,
            ),
          ),
          SizedBox(width: double.infinity, child: widget.widget),
          TextField(
            controller: widget.radiusController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: widget.radiusFlag,
          child: TextButton(
            onPressed: widget.reset,
            child: const Text('Reset'),
          ),
        ),
        TextButton(
          onPressed: widget.onPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class RadiusPopupAlert extends StatelessWidget {
  const RadiusPopupAlert({super.key});

  @override
  Widget build(BuildContext context) {
    FontTheme fontTheme = FontTheme();
    return AlertDialog(
      title: Text(
        'Invalid Input',
        style: TextStyle(
          fontFamily: fontTheme.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Please tap on the map first, before entering your radius.',
        style: TextStyle(
          fontFamily: fontTheme.fontFamily,
          fontSize: 12,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Unfocus any text field to prevent the keyboard from appearing
            FocusScope.of(context).unfocus();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

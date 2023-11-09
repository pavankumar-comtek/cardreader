import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/services.dart';

@immutable
class CustomDeviceTile extends StatefulWidget {
  const CustomDeviceTile(
      {Key? key,
      this.label,
      this.maxLength,
      this.deviceName,
      this.onTap,
      this.textStyle})
      : super(key: key);

  final String? label;
  final int? maxLength;
  final String? deviceName;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  @override
  State<CustomDeviceTile> createState() => _CustomDeviceTileState();
}

class _CustomDeviceTileState extends State<CustomDeviceTile> {
  bool isValid = true;

  int _maxLength() {
    if (widget.maxLength == null) {
      return 100;
    } else {
      return widget.maxLength!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.label != null)
        if (widget.label != null)
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Text(
                    widget.label!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              )),
      // child: Text(
      //   widget.label!,
      //   style: const TextStyle(fontWeight: FontWeight.w600),
      // ),

      Stack(
        children: [
          // Separate container with identical height of text field which is placed behind the actual textfield
          InkWell(
            onTap: widget.onTap,
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // color: Theme.of(context).cardColor,
                color: Colors.grey.shade200,
                boxShadow: const [
                  BoxShadow(
                    inset: true,
                    color: Colors.white,
                    blurRadius: 5, //extend the shadow
                    offset: Offset(-1, -4),
                  ),
                  BoxShadow(
                    inset: true,
                    color: Color.fromRGBO(180, 186, 194, 0.9),
                    blurRadius: 5, //extend the shadow
                    offset: Offset(5, 5),
                  )
                ],
                // boxShadow: UIParameters.getShadow(context)
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: widget.onTap,
                    child: Text(widget.deviceName ?? "Device",
                        style: widget.textStyle)),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}

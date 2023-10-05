import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/services.dart';

@immutable
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {Key? key,
      this.label,
      this.lableIcon,
      this.onlableIconClick,
      this.controller,
      this.hintText,
      this.labelStyle,
      this.enableObscure = false,
      this.hintStyle,
      this.textInputType,
      this.isEnabled,
      this.prefixIcon,
      this.onChange,
      this.suffixIcon,
      this.initialValue,
      this.validate,
      this.maxLength,
      this.inputFormatter,
      this.suffixCallback,
      this.prefixText,
      this.inputformateNumber,
      this.showbelowline})
      : super(key: key);

  final String? label;
  final IconData? lableIcon;
  final Function()? onlableIconClick;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool enableObscure;
  // final List<FilteringTextInputFormatter>? inputFormatter;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? textInputType;
  final bool? isEnabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String val)? onChange;
  final String? initialValue;
  final String? Function(String? val)? validate;
  final int? maxLength;
  final VoidCallback? suffixCallback;
  final String? prefixText;
  final bool? inputformateNumber;
  final bool? showbelowline;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
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
                  widget.lableIcon != null
                      ? Text(
                          widget.label!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      : Expanded(
                          child: Text(
                          widget.label!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )),
                  const SizedBox(
                    width: 8,
                  ),
                  if (widget.lableIcon != null)
                    InkWell(
                        onTap: () {
                          if (widget.onlableIconClick != null) {
                            widget.onlableIconClick!();
                          }
                        },
                        child: Icon(widget.lableIcon,
                            size: 16, color: !isValid ? Colors.red : null)),
                ],
              )),
      // child: Text(
      //   widget.label!,
      //   style: const TextStyle(fontWeight: FontWeight.w600),
      // ),

      Stack(
        children: [
          // Separate container with identical height of text field which is placed behind the actual textfield
          Container(
            height: 56,
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
          ),
          // child:
          TextFormField(
            // style: textformFieldStyle(context),
            keyboardType: widget.textInputType,
            controller: widget.controller,
            enabled: widget.isEnabled,
            obscureText: widget.enableObscure,
            validator: widget.validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // maxLength: _maxLength(),
            inputFormatters: (widget.inputformateNumber ?? false)
                ? [LengthLimitingTextInputFormatter(16)]
                : widget.inputFormatter,
            // inputFormatters: widget.inputFormatter,
            onChanged: (val) {
              if (widget.onChange != null) widget.onChange!(val);
            },

            initialValue: widget.initialValue,
            expands: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  )),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
              hintText: widget.hintText,
              labelStyle: widget.labelStyle,
              prefixText:
                  (widget.prefixText == null) ? null : widget.prefixText,
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(widget.prefixIcon,
                      size: 16, color: !isValid ? Colors.red : null),
              suffixIcon: widget.suffixIcon == null
                  ? null
                  : (widget.suffixCallback == null
                      ? InkWell(
                          onTap: () {
                            if (widget.onlableIconClick != null) {
                              widget.onlableIconClick!();
                            }
                          },
                          child: Icon(widget.suffixIcon,
                              size: 16,
                              color:
                                  !isValid ? Colors.red : Colors.grey.shade500))
                      : IconButton(
                          onPressed: widget.suffixCallback!,
                          icon: Icon(widget.suffixIcon,
                              size: 16,
                              color: !isValid
                                  ? Colors.red
                                  : Colors.grey.shade500))),
            ),
          ),
        ],
      ),
      widget.showbelowline ?? false
          ? Align(
              alignment: Alignment.centerRight,
              child: Text(
                "(Max \$500)",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.normal,
                  height: 1.00,
                ),
              ),
            )
          : const SizedBox(
              height: 0,
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

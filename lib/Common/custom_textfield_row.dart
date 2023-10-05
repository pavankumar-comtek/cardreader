import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/services.dart';

@immutable
class CustomTextFormFieldRow extends StatefulWidget {
  const CustomTextFormFieldRow(
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
      this.onPerClick,
      this.suffixIcon,
      this.initialValue,
      this.validate,
      this.maxLength,
      this.inputFormatter,
      this.suffixCallback,
      this.prefixText,
      this.inputformateNumber,
      this.showbelowline,
      this.showBackground,
      this.settext})
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
  final Function(double val)? onPerClick;
  final String? initialValue;
  final String? Function(String? val)? validate;
  final int? maxLength;
  final VoidCallback? suffixCallback;
  final String? prefixText, settext;
  final bool? inputformateNumber;
  final bool? showbelowline, showBackground;
  @override
  State<CustomTextFormFieldRow> createState() => _CustomTextFormFieldRowState();
}

class _CustomTextFormFieldRowState extends State<CustomTextFormFieldRow> {
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
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        if (widget.label != null)
          if (widget.label != null)
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.lableIcon != null
                            ? Text(
                                widget.label!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              )
                            : Expanded(
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.label!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ))),
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
                                  size: 16,
                                  color: !isValid ? Colors.red : null)),
                      ],
                    ))),
        // child: Text(
        //   widget.label!,
        //   style: const TextStyle(fontWeight: FontWeight.w600),
        // ),

        Flexible(
            child: Column(children: [
          Stack(
            children: [
              // Separate container with identical height of text field which is placed behind the actual textfield
              widget.showBackground ?? true
                  ? Container(
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
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              // child:
              widget.showBackground ?? true
                  ? Row(children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        // style: textformFieldStyle(context),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 14),
                          hintText: widget.hintText,
                          labelStyle: widget.labelStyle,
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.only(bottom: 70.0),
                          //   child: Icon(
                          //     Icons.topic_rounded,
                          //   ),
                          // ),
                          // prefixIcon: Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 156),
                          //     // child: Align(
                          //     //     alignment: Alignment.center,
                          //     child: Text('\$')),
                          // prefix: const Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Padding(
                          //       padding: EdgeInsets.only(left: 6),
                          //       // padding: EdgeInsets.symmetric(horizontal: 256),

                          //       child: Text("\$")),
                          // ),
                          // suffix: Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: Text("\$"),
                          // ),
                          // prefix: Align(
                          //     alignment: Alignment.centerRight,
                          //     //  Padding(
                          //     // padding: const EdgeInsets.symmetric(horizontal: 16),
                          //     child: (widget.prefixText == null)
                          //         ? null
                          //         : Text('${widget.prefixText}')),
                          prefixText: (widget.prefixText == null)
                              ? null
                              : widget.prefixText,
                          // prefixIcon: widget.prefixIcon == null
                          //     ? null
                          //     : Icon(widget.prefixIcon,
                          //         size: 16, color: !isValid ? Colors.red : null),
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
                                          color: !isValid
                                              ? Colors.red
                                              : Colors.grey.shade500))
                                  : IconButton(
                                      onPressed: widget.suffixCallback!,
                                      icon: Icon(widget.suffixIcon,
                                          size: 16,
                                          color: !isValid
                                              ? Colors.red
                                              : Colors.grey.shade500))),
                        ),
                      ))
                    ])
                  : const SizedBox(
                      width: 0,
                    ),

              widget.showBackground ?? true
                  ? const SizedBox(
                      width: 0,
                    )
                  : Container(
                      // padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(left: 0, top: 0, right: 20),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${widget.settext}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              // fontSize: 16,
                              // fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              // height: 1.00,
                            ),
                          ))),
            ],
          ),
        ])),

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
      ]),
      widget.showBackground ?? true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Flexible(
                //     flex: 1,
                //     child:
                Container(
                  // height: 56,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 0, top: 5, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                  child: InkWell(
                    child: Text(
                      '18%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      if (widget.onPerClick != null) {
                        widget.onPerClick!(18.0);
                      }
                    },
                  ),
                ),
                //     ),
                // Flexible(
                //   flex: 1,
                //   child:
                Container(
                    // height: 56,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 0, top: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                    child: InkWell(
                      child: Text(
                        '20%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        if (widget.onPerClick != null) {
                          widget.onPerClick!(20.0);
                        }
                      },
                    )),
                // ),
                // Flexible(
                //   flex: 1,
                //   child:
                Container(
                    // height: 56,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 0, top: 5, right: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                    child: InkWell(
                      child: Text(
                        '25%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        if (widget.onPerClick != null) {
                          widget.onPerClick!(25.0);
                        }
                      },
                    )),
                // ),
              ],
            )
          : const SizedBox(
              width: 0,
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

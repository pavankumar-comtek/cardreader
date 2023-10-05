import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cardreader/Common/ui_parameters.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.label, this.onTap, this.isEnabled})
      : super(key: key);

  final String label;
  final VoidCallback? onTap;
  final bool? isEnabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.maxFinite,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(60, 122, 245, 0.4000000059604645),
                offset: Offset(0, 8),
                blurRadius: 16)
          ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(68, 153, 254, 1),
                Color.fromRGBO(51, 91, 235, 1)
              ])),
      // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child:
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            Padding(
                // padding: const EdgeInsets.all(12.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                    child: Text(
                  label,
                  // textAlign: TextAlign.end,
                  style: defaultTs(context).merge(TextStyle(
                    color: (isEnabled ?? true)
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context).focusColor.withOpacity(0.3),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    // height: 1.5
                  )),
                ))),
        //   ],
      ),
    );
    //   decoration: BoxDecoration(boxShadow: UIParameters.getShadow(context)),
    //   width: double.maxFinite,
    //   child: NeumorphicButton(
    //     onPressed: onTap,
    //     padding: EdgeInsets.all(const RD(s: 4).get(context) ?? 4),
    //     style: NeumorphicStyle(
    //         shadowLightColor: Colors.transparent,
    //         shadowDarkColor: Theme.of(context).shadowColor,
    //         shadowLightColorEmboss:
    //             onTap == null ? Colors.white24 : Colors.blue[900],
    //         shadowDarkColorEmboss: Colors.white.withOpacity(0.9),
    //         shape: NeumorphicShape.flat,
    //         color: (isEnabled ?? true)
    //             ? kButtonsColor
    //             : Theme.of(context).accentColor.withOpacity(0.1),
    //         depth: (isEnabled ?? true) ? -5 : 1,
    //         surfaceIntensity: 10,
    //         lightSource: LightSource.topLeft,
    //         boxShape: NeumorphicBoxShape.roundRect(
    //             BorderRadius.circular(kButtondBorderRadius))),
    //     child: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Center(
    //         child: Text(
    //           label,
    //           style: defaultTs(context).merge(TextStyle(
    //               color: (isEnabled ?? true)
    //                   ? Theme.of(context).colorScheme.onBackground
    //                   : Theme.of(context).focusColor.withOpacity(0.3),
    //               fontWeight: FontWeight.bold)),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CustomButton_main extends StatelessWidget {
  const CustomButton_main(
      {Key? key, required this.label, this.onTap, this.isEnabled})
      : super(key: key);

  final String label;
  final VoidCallback? onTap;
  final bool? isEnabled;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        // child: Ink(
        child: Container(
          // width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                inset: true,
                color: Color.fromRGBO(180, 186, 194, 0.9),
                // color: Colors.white,
                blurRadius: 5, //extend the shadow
                offset: Offset(-5, -5),
              ),
              BoxShadow(
                inset: true,
                color: Colors.white,
                // color: Color.fromRGBO(180, 186, 194, 0.9),
                blurRadius: 5, //extend the shadow
                offset: Offset(1, 4),
              )
            ],
            // gradient: kButtonGradient
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: InkWell(
            onTap: onTap,
            child:
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                Padding(
                    // padding: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Center(
                        child: Text(
                      label,
                      // textAlign: TextAlign.end,
                      style: defaultTs(context).merge(TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        // height: 1.5
                      )),
                    ))),
            //   ],
          ),
        ));
  }
}

TextStyle defaultTs(context) =>
    TextStyle(fontSize: const RD(d: 16, t: 16, m: 16, s: 14).get(context));

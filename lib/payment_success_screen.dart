import 'dart:convert';

import 'package:cardreader/utils/color_constant.dart';
import 'package:cardreader/utils/common_scaffold.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';

import 'Common/custom_button.dart';
import 'Common/dailog.dart';

import 'finish_screen.dart';

class PaymentSuccess extends StatefulWidget {
  double totalamount;
  String referal, token, myurl;
  PaymentSuccess(this.totalamount, this.referal, this.token, this.myurl,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentSuccessState();
  }
}

class PaymentSuccessState extends State<PaymentSuccess> {
  // CardFieldInputDetails? _card;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Payment Complete',
      body: Column(
        children: <Widget>[
          // const SizedBox(
          //   height: 30,
          // ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),

          const SizedBox(
            height: 20,
          ),

          Text("Payment of \$${widget.totalamount} is successful",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.bluegray600,
                fontSize: 16,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                // height: 1.00,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            alignment: Alignment.center, // This is needed
            child: Image.asset(
              'assets/images/success.png',
              fit: BoxFit.contain,
              width: 80,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            // height: 56,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // color: Theme.of(context).cardColor,
              // color: Colors.grey.shade200,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: Text(
                        "Scan and download DoGetGo for seamles rides. convenient payments and more.",
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorConstant.bluegray600,
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          // height: 1.00,
                        ))),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      // boxShadow: UIParameters.getShadow(context),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(40),
                        // margin: const EdgeInsets.symmetric(
                        //     vertical: 25, horizontal: 35),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     color: Theme.of(context)
                        //         .primaryColor
                        //         .withOpacity(0.15)),
                        // child: Image.asset('assets/image)s/QR.png'),
                        child: qrCodeImage(''),
                      ),
                      // controller.qrLoading.value == true
                      //     ? const Center()
                      //     : CustomTextFormField(
                      //         suffixIcon: AppIcons.doc,
                      //         initialValue: controller.qrAddress.value,
                      //       )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //     // padding: const EdgeInsets.symmetric(vertical: 8.0),
          //     margin: const EdgeInsets.only(
          //         left: 10, top: 10, right: 10, bottom: 10),
          //     child: Text(
          //         "To reward your driver, please enter the below referral code during your Sign-Up to DoGetGo app.",
          //         textAlign: TextAlign.center,
          //         // overflow: TextOverflow.ellipsis,
          //         style: TextStyle(
          //           color: Colors.grey.shade600,
          //           fontSize: 14,
          //           // fontFamily: 'Urbanist',
          //           fontWeight: FontWeight.w500,
          //           // height: 1.00,
          //         ))),
          Container(
              // padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Driver Referral Code',
                            style: TextStyle(
                              color: ColorConstant.bluegray600,
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            displaydialog(
                                context,
                                'Referral Code',
                                'To reward your driver, please enter the below referral code during your Sign-Up to DoGetGo app.',
                                '',
                                'Close',
                                1);
                          },
                          child: Icon(
                            Icons.help_outline,
                            size: 20,
                            color: ColorConstant.bluegray600,
                            // color: !isValid ? Colors.red : null
                          )),
                    ],
                  ))),
          // Container(
          //     // padding: const EdgeInsets.symmetric(vertical: 8.0),
          //     margin: const EdgeInsets.only(left: 16, top: 20, right: 16),
          //     child: Align(
          //         alignment: Alignment.center,
          //         child: Text(
          //           "Driver Referral Code",
          //           overflow: TextOverflow.ellipsis,
          //           textAlign: TextAlign.left,
          //           style: TextStyle(
          //             color: Colors.grey.shade700,
          //             fontSize: 16,
          //             fontFamily: 'Urbanist',
          //             fontWeight: FontWeight.w700,
          //             height: 1.00,
          //           ),
          //         ))),
          // Expanded(
          //   child:
          Container(
              // padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.referal,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.bluegray600,
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.00,
                  ),
                ),
              )),
          // ),
          Container(
              // padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
              child: CustomButton(
                  label: 'Home',
                  onTap: () async {
                    print('Flutter Module -RAMAMMAMAMA Exit the APP 22');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const Finish()),
                    // );
                    // Get.offAll('/');
                    SystemNavigator.pop();
                    // Navigator.of(context).pop(true);
                    // Navigator.of(context).pop(true);
                    // Navigator.of(context).pop(true);
                    // FlutterWindowClose.setWebReturnValue('Are you sure?');

                    // html.window.open('https://play.google.com/store/apps/details?id=com.rydeum.partner',"_blank");
                    //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    // html.window.close();

                    // debugger();
                    // exit(0);
                    // SystemNavigator.pop();
                    // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Payment(widget.myurl,
                    //           widget.referal, widget.token)),
                    // );
                  })),
        ],
      ),
    );
  }
}

Image qrCodeImage(String qrImage) {
  if (qrImage == '') {
    return Image.asset('assets/images/QR.png');
  } else {
    try {
      return Image.memory(base64Decode(qrImage));
    } catch (e) {
      return Image.asset('assets/images/QR.png');
    }
  }
}

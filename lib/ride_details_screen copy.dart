// ignore_for_file: sort_child_properties_last

import 'dart:typed_data';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cardreader/Api/API.dart';
import 'package:cardreader/Common/dailog.dart';
import 'package:cardreader/payment_success_screen.dart';

import 'Common/custom_button.dart';
import 'Common/custom_textfield.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'Common/custom_textfield_Row.dart';
import 'Common/numberformat.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RideDetails1 extends StatefulWidget {
  double amount;
  String token,
      firstname,
      lastname,
      cardtype,
      country,
      cardNumber,
      cvvCode,
      expMonth,
      expYear,
      zipCode,
      referal,
      myurl;

  RideDetails1(
      this.token,
      this.amount,
      this.firstname,
      this.lastname,
      this.cardtype,
      this.country,
      this.cardNumber,
      this.cvvCode,
      this.expMonth,
      this.expYear,
      this.zipCode,
      this.referal,
      this.myurl,
      {Key? key})
      : super(key: key);
  // const RideDetails({Key? key, required this.amount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RideDetailsState1();
  }
}

class RideDetailsState1 extends State<RideDetails1> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  double tip = 0;
  late double totalamount, processingfee;

  @override
  void initState() {
    processingfee = roundOffToXDecimal((widget.amount * 0.05)).toDouble();

    totalamount =
        roundOffToXDecimal((widget.amount + processingfee)).toDouble();
    // '\$${roundOffToXDecimal(widget.amount * 0.02).toDouble()}'

    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  Future<File> writeImageTemp(Uint8List base64Image, String imageName) async {
    final dir = await getTemporaryDirectory();
    await dir.create(recursive: true);
    final tempFile = File(path.join(dir.path, imageName));
    await tempFile.writeAsBytes(base64Image);
    return tempFile;
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    // var filename =
    //     await writeImageTemp(bytes!.buffer.asUint8List(), "signatureimage.png");

    // print('RAMAMMAMAMAMA file name::  $filename');
    // signatureFileUpload(filename);

    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         appBar: AppBar(),
    //         body: Center(
    //           child: Container(
    //             color: Colors.grey[300],
    //             child: Image.memory(bytes!.buffer.asUint8List()),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            // image: !useBackgroundImage
            //     ? const DecorationImage(
            //         image: ExactAssetImage('assets/bg.png'),
            //         fit: BoxFit.fill,
            //       )
            //     : null,
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // const SizedBox(
                //   height: 30,
                // ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // const SizedBox(
                //   height: 30,
                // ),

                CustomTextFormFieldRow(
                  // prefixIcon: AppIcons.location,
                  label: 'Ride Amount',
                  hintText: 'Your zipcode',
                  textInputType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    LengthLimitingTextInputFormatter(5)
                  ],
                  maxLength: 5,
                  onChange: (val) {
                    // zipcode = val;
                  },
                  validate: (val) {
                    if (val == '') {
                      return 'This field is mandatory';
                    }
                    return null;
                  },
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ride Amount",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.normal,
                                  height: 1.00,
                                ),
                              )))),
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 30, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${widget.amount}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                  height: 1.00,
                                ),
                              )))),
                ]),
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 10, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tip (Optional)",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.normal,
                                  height: 1.00,
                                ),
                              )))),
                  Expanded(
                      child: Container(
                    // padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                    child: CustomTextFormField(
                        // prefixIcon: Icons.mail,
                        // suffixIcon: _isObscure
                        //     ? Icons.visibility
                        //     : Icons.visibility_off,
                        // suffixCallback: () {
                        //   setState(() {
                        //     _isObscure = !_isObscure;
                        //   });
                        // },
                        label: '10',
                        // hintText: 'Enter password',
                        // initialValue: '10',
                        // enableObscure: !_isObscure,
                        validate: (val) {
                          // if (val == '') {
                          //   return 'Please enter Password';
                          // } else if (val!.length < 8) {
                          //   return 'Use 8 characters or more for your password';
                          // }
                          return null;
                        },
                        onChange: (value) {
                          setState(() {
                            tip = double.parse(value.toString());
                            // totalamount = tip + widget.amount;
                            processingfee = roundOffToXDecimal(
                                    ((widget.amount + tip) * 0.05))
                                .toDouble();

                            totalamount = roundOffToXDecimal(
                                    (widget.amount + tip + processingfee))
                                .toDouble();

                            // print(
                            //     'RAMAMAMAMMAAM totalamount : $totalamount processingfee: $processingfee');
                          });
                        }),
                  )),
                ]),
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Processing Fee",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.normal,
                                  height: 1.00,
                                ),
                              )))),
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 30, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$processingfee',
                                // ' ${roundOffToXDecimal((widget.amount * 0.05)).toDouble()}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                  height: 1.00,
                                ),
                              )))),
                ]),
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total amount",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.normal,
                                  height: 1.00,
                                ),
                              )))),
                  Expanded(
                      child: Container(
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 30, top: 30, right: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$totalamount',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  // fontSize: 16,
                                  // fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600,
                                  // height: 1.00,
                                ),
                              )))),
                ]),
                Container(
                    // padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 40, right: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "E-Sign",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            height: 1.00,
                          ),
                        ))),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   margin: const EdgeInsets.only(left: 16, top: 16, right: 16),

                //   child:
                Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: SfSignaturePad(
                                key: signatureGlobalKey,
                                // backgroundColor: Colors.white,
                                strokeColor: Colors.black,
                                minimumStrokeWidth: 1.0,
                                maximumStrokeWidth: 4.0),
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
                          )),
                      const SizedBox(height: 10),
                      // Row(children: <Widget>[
                      //   TextButton(
                      //     child: const Text('Done'),
                      //     onPressed: _handleSaveButtonPressed,
                      //   ),
                      //   TextButton(
                      //     child: const Text('Clear'),
                      //     onPressed: _handleClearButtonPressed,
                      //   )
                      // ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center),
                // ),
                Container(
                    // padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
                    child: CustomButton(
                        label: 'Confirm Payment',
                        onTap: () async {
                          // _handleSaveButtonPressed();
                          Map data = {
                            'fname': widget.firstname,
                            'lname': widget.lastname,
                            'cardType': widget.cardtype,
                            'country': widget.country,
                            'cardnumber': widget.cardNumber,
                            'cvc': widget.cvvCode,
                            'expmonth': widget.expMonth,
                            'expyear': widget.expYear,
                            'amount': totalamount,
                            'signatureUrl':
                                'https://api.rydeum.info/utility/getImage/IMG_166971478095.jpeg',
                            'tipAmount': tip,
                            'zipCode': widget.zipCode,
                          };
                          callPaymentAPI(data, widget.token, totalamount,
                              widget.referal, widget.myurl);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const PaymentSuccess()),
                          // );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void callPaymentAPI(Map data, String token, double totalamount,
      String referal, String myurl) {
    print('TOKEEENNENNE callPaymentAPI : $token');
    final api = API();
    api.dopayment(data, token).then((value) {
      print("rrrrrrrrrrrrrrr successss");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaymentSuccess(totalamount, referal, token, myurl)),
      );
      // loading = false;
    }).catchError((error) {
      print('RAMAMAMAMMAMA ${error.toString()}');
      displaydialog(
          context,
          'Payment Failed',
          'Card details entered are invalid. Please enter valid card details and try again.',
          '',
          'Retry',
          2);
      // AppLogger.d(error.toString());
      // displaydialog(context, 'Alert', error.toString(), 1);
      // loading = false;
      // notifyListeners();
    });
  }

  signatureFileUpload(File file) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.rydeum.info/utility/uploadImage"));
    //add text fields
    // request.fields["lan"] = 'en';
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }
}

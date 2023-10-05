// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:easy_separator/easy_separator.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cardreader/Api/API.dart';
import 'package:cardreader/Common/dailog.dart';
import 'package:cardreader/Common/other.dart';
import 'package:cardreader/payment_success_screen.dart';

import 'Common/custom_button.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'Common/custom_textfield_Row.dart';
import 'Common/numberformat.dart';
import 'dart:io';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RideDetails extends StatefulWidget {
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

  RideDetails(
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
    return RideDetailsState();
  }
}

class RideDetailsState extends State<RideDetails> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _textController =
      TextEditingController(text: '\$');
  final String _userPostfix = "\$";
  final _controller = TextEditingController(text: '\$');
  // final _controller = TextEditingController();

  double tip = 0;
  late double totalamount = 0.0, processingfee = 0.0;
  late bool isSignatureDraw = false;

  @override
  void initState() {
    super.initState();

    loaddata();
    // processingfee = roundOffToXDecimal((widget.amount * 0.05)).toDouble();

    // totalamount =
    //     roundOffToXDecimal((widget.amount + processingfee)).toDouble();
  }

  void loaddata() async {
    processingfee = roundOffToXDecimal((widget.amount * 0.05)).toDouble();

    totalamount =
        roundOffToXDecimal((widget.amount + processingfee)).toDouble();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
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
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                  // padding: UIParameters.contentPadding,
                  child: SafeArea(
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: IntrinsicHeight(
                                child: Form(
                                    key: formKey,
                                    child: EasySeparatedColumn(
                                      separatorBuilder: (_, __) {
                                        return const SizedBox(height: 10);
                                      },
                                      children: [
                                        Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            const Expanded(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Tip & E-Sign",
                                                      // overflow: TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.00,
                                                      ),
                                                    ))),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        CustomTextFormFieldRow(
                                          label: 'Ride Amount',
                                          showBackground: false,
                                          initialValue: '\$${widget.amount}',
                                          textInputType: TextInputType.number,
                                          settext: '\$${widget.amount}',
                                          inputFormatter: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                                            // LengthLimitingTextInputFormatter(5)
                                          ],
                                          maxLength: 5,
                                          onChange: (val) {
                                            // zipcode = val;
                                          },
                                          validate: (val) {
                                            return null;
                                          },
                                        ),
                                        CustomTextFormFieldRow(
                                          label: 'Tip (Optional)',
                                          textInputType: TextInputType.number,
                                          // inputFormatter: [
                                          //   FilteringTextInputFormatter.allow(
                                          //       RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          // ],
                                          controller: _controller,
                                          onChange: (value) {
                                            // print(
                                            //     'RAMMAMAMAMMA entered value $value');
                                            // _controller.text = _userPostfix +
                                            //     removeDollar(value.toString());
                                            // // print(
                                            // //     'RAMMAMAMAMMA final value ${_controller.text}');
                                            // _controller.selection =
                                            //     TextSelection.fromPosition(
                                            //         TextPosition(
                                            //             offset: _controller.text
                                            //                 .toString()
                                            //                 .length));
                                            setState(() {
                                              _controller.text = _userPostfix +
                                                  removeDollar(
                                                      value.toString());
                                              // print(
                                              //     'RAMMAMAMAMMA final value ${_controller.text}');
                                              _controller.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset: _controller
                                                              .text
                                                              .toString()
                                                              .length));
                                              value = removeDollar(
                                                  value.toString());
                                              if (value != '') {
                                                tip = double.parse(
                                                    value.toString());
                                                processingfee =
                                                    roundOffToXDecimal(
                                                            ((widget.amount +
                                                                    tip) *
                                                                0.05))
                                                        .toDouble();

                                                totalamount =
                                                    roundOffToXDecimal(
                                                            (widget.amount +
                                                                tip +
                                                                processingfee))
                                                        .toDouble();
                                              }
                                            });
                                          },
                                          onPerClick: (value) {
                                            setState(() {
                                              tip = value;
                                              _controller.text =
                                                  _userPostfix + tip.toString();
                                              processingfee =
                                                  roundOffToXDecimal(
                                                          ((widget.amount +
                                                                  tip) *
                                                              0.05))
                                                      .toDouble();

                                              totalamount = roundOffToXDecimal(
                                                      (widget.amount +
                                                          tip +
                                                          processingfee))
                                                  .toDouble();
                                            });
                                          },
                                          validate: (val) {
                                            if (tip > 100) {
                                              return 'Limit Exceeded';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        CustomTextFormFieldRow(
                                          label: 'Convenience Fee',
                                          showBackground: false,
                                          initialValue: '\$$processingfee',
                                          textInputType: TextInputType.number,
                                          settext: '\$$processingfee',
                                          inputFormatter: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                                            // LengthLimitingTextInputFormatter(5)
                                          ],
                                          maxLength: 5,
                                          onChange: (val) {
                                            // zipcode = val;
                                          },
                                          validate: (val) {
                                            return null;
                                          },
                                        ),
                                        CustomTextFormFieldRow(
                                          label: 'Total Amount',
                                          showBackground: false,
                                          initialValue: '\$$totalamount',
                                          textInputType: TextInputType.number,
                                          settext: '\$$totalamount',
                                          inputFormatter: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                                            // LengthLimitingTextInputFormatter(5)
                                          ],
                                          maxLength: 5,
                                          onChange: (val) {
                                            // zipcode = val;
                                          },
                                          validate: (val) {
                                            return null;
                                          },
                                        ),

                                        Container(
                                            // padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            margin: const EdgeInsets.only(
                                                left: 0, top: 10, right: 16),
                                            child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("E-Sign",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600)
                                                    // TextStyle(
                                                    //   color: Colors.grey.shade700,
                                                    //   fontSize: 16,
                                                    //   fontFamily: 'Urbanist',
                                                    //   fontWeight: FontWeight.w700,
                                                    //   height: 1.00,
                                                    // ),
                                                    ))),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        //   margin: const EdgeInsets.only(left: 16, top: 16, right: 16),

                                        //   child:
                                        Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Container(
                                                    height: 300,
                                                    child: SfSignaturePad(
                                                        key: signatureGlobalKey,
                                                        onDrawEnd: () {
                                                          isSignatureDraw =
                                                              true;
                                                          print(
                                                              'RAMAMMAMAA onDrawEnd');
                                                        },
                                                        // backgroundColor: Colors.white,
                                                        strokeColor:
                                                            Colors.black,
                                                        minimumStrokeWidth: 1.0,
                                                        maximumStrokeWidth:
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      // color: Theme.of(context).cardColor,
                                                      color:
                                                          Colors.grey.shade200,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          inset: true,
                                                          color: Colors.white,
                                                          blurRadius:
                                                              5, //extend the shadow
                                                          offset:
                                                              Offset(-1, -4),
                                                        ),
                                                        BoxShadow(
                                                          inset: true,
                                                          color: Color.fromRGBO(
                                                              180,
                                                              186,
                                                              194,
                                                              0.9),
                                                          blurRadius:
                                                              5, //extend the shadow
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center),
                                        // ),
                                        Container(
                                            // padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            margin: const EdgeInsets.only(
                                                left: 16, top: 10, right: 16),
                                            child: CustomButton(
                                                label: 'Confirm Payment',
                                                onTap: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    if (isSignatureDraw) {
                                                      // handleSaveButtonPressed();
                                                      Map data = {
                                                        'fname':
                                                            widget.firstname,
                                                        'lname':
                                                            widget.lastname,
                                                        'cardType':
                                                            widget.cardtype,
                                                        'country':
                                                            widget.country,
                                                        'cardnumber':
                                                            widget.cardNumber,
                                                        'cvc': widget.cvvCode,
                                                        'expmonth':
                                                            widget.expMonth,
                                                        'expyear':
                                                            widget.expYear,
                                                        'amount': totalamount,
                                                        'signatureUrl':
                                                            await uint8ListTob64(),
                                                        // 'signatureUrl':
                                                        //     'https://api.rydeum.info/utility/getImage/IMG_166971478095.jpeg',
                                                        'tipAmount': tip,
                                                        'zipCode':
                                                            widget.zipCode,
                                                      };
                                                      callPaymentAPI(
                                                          data,
                                                          widget.token,
                                                          totalamount,
                                                          widget.referal,
                                                          widget.myurl);
                                                    } else {
                                                      displaydialog(
                                                          context,
                                                          'E-Sign',
                                                          'Please Sign before payment',
                                                          '',
                                                          'OK',
                                                          1);
                                                    }
                                                  }
                                                })),
                                      ],
                                    ))),
                          ))));
            })));
  }

  void callPaymentAPI(Map data, String token, double totalamount,
      String referal, String myurl) {
    print('TOKEEENNENNE callPaymentAPI : $token');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PaymentSuccess(totalamount, referal, token, myurl)),
    );
    // final api = API();
    // api.dopayment(data, token).then((value) {
    //   print("rrrrrrrrrrrrrrr successss");
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             PaymentSuccess(totalamount, referal, token, myurl)),
    //   );
    //   // loading = false;
    // }).catchError((error) {
    //   print('RAMAMAMAMMAMA ${error.toString()}');
    //   displaydialog(
    //       context,
    //       'Payment Failed',
    //       'Card details entered are invalid. Please enter valid card details and try again.',
    //       '',
    //       'Retry',
    //       2);
    //   // AppLogger.d(error.toString());
    //   // displaydialog(context, 'Alert', error.toString(), 1);
    //   // loading = false;
    //   // notifyListeners();
    // });
  }

  Future<File> writeImageTemp(Uint8List base64Image, String imageName) async {
    final dir = await getTemporaryDirectory();
    await dir.create(recursive: true);
    final tempFile = File(path.join(dir.path, imageName));
    await tempFile.writeAsBytes(base64Image);
    return tempFile;
  }

  void saveSignatureImage() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    var filename =
        await writeImageTemp(bytes!.buffer.asUint8List(), "signatureimage.png");

    print('RAMAMMAMAMAMA file name::  $filename');
    signatureFileUpload(filename);
  }

  signatureFileUpload(File file) async {
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

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory? tempDir = await getDownloadsDirectory();
    String? tempPath = tempDir?.path;
    var filePath = '${tempPath!}/file_01.tmp';
    print(
        'RAMAMRAMRMRAMR:: filepath $filePath'); // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void convertedToBase64(String value) async {
    // final File fileForFirebase = File(platformFile!.path.toString());
    final File fileForFirebase = File(value);
    final bytes = Io.File(fileForFirebase.path).readAsBytesSync();
    String base64Encode = base64.encode(bytes);
    log('base64Encode:: \n');
    log(base64Encode);
    log('\nEnd Log');
  }

  Future<String> uint8ListTob64() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    final buffer = bytes?.buffer;
    String base64String = base64Encode(
        buffer!.asUint8List(bytes!.offsetInBytes, bytes.lengthInBytes));
    // String header = "data:image/png;base64,";
    // return header + base64String;
    // log('base64Encode:: \n');
    // log(base64String);
    // log('\nEnd Log');
    return base64String;
  }

  void handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    final buffer = bytes?.buffer;

    var filename = await writeToFile(bytes!);
    print('RAMAMMAMAMAMA file name::  $filename');
    signatureFileUpload(filename);
  }
}

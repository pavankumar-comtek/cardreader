import 'dart:developer';

import 'package:cardreader/models/cardtoken_response.dart';
import 'package:easy_separator/easy_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:cardreader/ride_details_screen.dart';
import 'package:cardreader/api/API.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'Common/custom_button.dart';
import 'Common/custom_textfield.dart';
import 'Common/dailog.dart';
import 'finish_screen.dart';

class Payment extends StatefulWidget {
  String myurl, referal, token, cardNumber, expiryDate, cardHolderName;
  Payment(this.myurl, this.referal, this.token, this.cardNumber,
      this.expiryDate, this.cardHolderName,
      {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<Payment> {
  // CardFieldInputDetails? _card;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  String lastName = '';
  String cvvCode = '';
  String zipCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  late double amount;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textfieldcontroller =
      TextEditingController(text: '\$0.0');

  // CardEditController cardEditController = CardEditController();
  CardFieldInputDetails? cardFieldInputDetails;

  @override
  void initState() {
    // storedata();
    border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );

    super.initState();
    cardNumber = widget.cardNumber;
    cardNumberController.text = widget.cardNumber;
    cardHolderNameController.text = widget.cardHolderName;
    cardHolderName = widget.cardHolderName;
    print("Flutter Module -Expriry Date :: ${widget.expiryDate}");
    expiryDateController.text = widget.expiryDate != ""
        ? widget.expiryDate.substring(2) +
            "/" +
            widget.expiryDate.substring(0, 2)
        : "";
    print("Flutter Module -expiry Date :: ${expiryDateController.text}");
    expiryDate = widget.expiryDate != ""
        ? widget.expiryDate.substring(2) +
            "/" +
            widget.expiryDate.substring(0, 2)
        : "";

    //generateStripeToken();
  }

  void generateStripeToken(CardDetails cardDetails) async {
    try {
      // log("Card Details are:: ${cardEditController.details.number}");

      await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
      CreateTokenParams createTokenParams = const CreateTokenParams.card(
          params: CardTokenParams(type: TokenType.Card));
      TokenData token = await Stripe.instance.createToken(createTokenParams);
      print("Flutter Module  -Stripe token generated:: ${token.id}");
      //below code sends stripe token to backend.
      generateToken(token.id);
      // api.chargeCardConvinienceFees(amount, token.id).then((value) {
      //    callGetCountryCode(cardNumber.substring(0, 6), token.id,
      //    value['convenienceFee'],value['appCommission'],value['operatorCommission'],value['chargeAmount']);
      // });

      //  generateToken(token.id);
    } catch (e) {
      print("Flutter Module -Error in generating Stripe Token $e");
      rethrow;
    }
  }

  //generate Token API
  Future<void> generateToken(String cardToken) async {
    print("Flutter Module -authToken is ${api.authToken}");
    try {
      final response =
          await api.generateToken(widget.cardHolderName, cardToken);

      print("Flutter Module -Token generated successfully");
      //  print("Flutter Module -Token is ${CardTokenResponse.fromJson(response)}");
      // await api.chargeCardConvinienceFees(100, authToken);
      CardTokenResponse cardTokenResponse =
          CardTokenResponse.fromJson(response);
      print("Flutter Module -Token is ${cardTokenResponse}");
      api.chargeCardConvinienceFees(amount).then((value) {
        callGetCountryCode(
            cardNumber.substring(0, 6),
            cardToken,
            value['convienceFee'],
            value['appCommission'],
            value['operatorCommission'],
            value['chargeAmount'],
            cardTokenResponse);
      }).catchError((e) {
        print("Flutter Module -Error in getting Convenience Fees $e");
      });
      // await api.chargeCard(1, cardTokenResponse.data.cards[0].id,
      //     cardTokenResponse.data.cards[0].customer, 10, authToken);
    } catch (e) {
      print("Flutter Module -Error in generating Token $e");
    }
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
                              padding: EdgeInsets.all(15),
                              child: IntrinsicHeight(
                                  child: Form(
                                      key: formKey,
                                      child: EasySeparatedColumn(
                                        separatorBuilder: (_, __) {
                                          return const SizedBox(height: 20);
                                        },
                                        children: [
                                          // Visibility(
                                          //   child: CardField(
                                          //     controller: cardEditController,
                                          //     decoration: const InputDecoration(
                                          //       labelText: 'Card Number',
                                          //     ),
                                          //     onCardChanged:
                                          //         (CardFieldInputDetails?
                                          //             card) {
                                          //       setState(() {
                                          //         cardFieldInputDetails = card;
                                          //       });
                                          //     },
                                          //   ),
                                          //   visible: false,
                                          // ),
                                          Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_back),
                                                  onPressed: () {
                                                    print(
                                                        'Flutter Module -RAMAMMAMAMA Exit the APP 22');
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => const Finish()),
                                                    // );
                                                    //   Get.back();
                                                    SystemNavigator.pop();
                                                  },
                                                ),
                                              ),
                                              const Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Card Payment",
                                                        // overflow: TextOverflow.ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'Urbanist',
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
                                          CustomTextFormField(
                                            // prefixIcon: AppIcons.mail,
                                            label: 'Card Details',
                                            hintText: 'Enter card number',
                                            controller: cardNumberController,
                                            lableIcon: Icons.help_outline,
                                            onlableIconClick: () {
                                              displaydialog(
                                                  context,
                                                  'Card Reference',
                                                  'All your information is safe and secured',
                                                  'assets/images/card_details.png',
                                                  'Close',
                                                  1);
                                            },
                                            textInputType: TextInputType.number,
                                            inputFormatter: [
                                              LengthLimitingTextInputFormatter(
                                                  16)
                                            ],
                                            enableObscure: true,
                                            onChange: (val) {
                                              cardNumber = val;
                                            },
                                            validate: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 16) {
                                                return 'Please enter a valid number';
                                              }
                                              return null;
                                            },
                                          ),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child:
                                                          CustomTextFormField(
                                                        // prefixIcon: AppIcons.mail,
                                                        label: 'Expiry date',
                                                        controller:
                                                            expiryDateController,
                                                        hintText:
                                                            'Enter Expiry date',
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        // inputformateNumber: true,
                                                        // maxLength: 16,
                                                        inputFormatter: [
                                                          CardExpirationFormatter(),
                                                          LengthLimitingTextInputFormatter(
                                                              5)
                                                        ],
                                                        enableObscure: true,
                                                        onChange: (val) {
                                                          expiryDate = val;
                                                        },
                                                        validate: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter a valid date';
                                                          }
                                                          final DateTime now =
                                                              DateTime.now();
                                                          final List<String>
                                                              date =
                                                              value.split(
                                                                  RegExp(r'/'));
                                                          final int month =
                                                              int.parse(
                                                                  date.first);
                                                          final int year =
                                                              int.parse(
                                                                  '20${date.last}');
                                                          final int lastDayOfMonth =
                                                              month < 12
                                                                  ? DateTime(
                                                                          year,
                                                                          month +
                                                                              1,
                                                                          0)
                                                                      .day
                                                                  : DateTime(
                                                                          year +
                                                                              1,
                                                                          1,
                                                                          0)
                                                                      .day;
                                                          final DateTime
                                                              cardDate =
                                                              DateTime(
                                                                  year,
                                                                  month,
                                                                  lastDayOfMonth,
                                                                  23,
                                                                  59,
                                                                  59,
                                                                  999);

                                                          if (cardDate.isBefore(
                                                                  now) ||
                                                              month > 12 ||
                                                              month == 0) {
                                                            return 'Please enter a valid date';
                                                          }
                                                          return null;
                                                        },
                                                      )),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child:
                                                          CustomTextFormField(
                                                        // prefixIcon: AppIcons.mail,
                                                        label: 'CVV/CVC',

                                                        lableIcon:
                                                            Icons.help_outline,
                                                        onlableIconClick: () {
                                                          displaydialog(
                                                              context,
                                                              'Card Reference',
                                                              'All your information is safe and secured',
                                                              'assets/images/card_details.png',
                                                              'Close',
                                                              1);
                                                        },
                                                        hintText:
                                                            'Enter CVV/CVC',
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        // inputformateNumber: true,
                                                        // maxLength: 16,
                                                        inputFormatter: [
                                                          LengthLimitingTextInputFormatter(
                                                              4)
                                                        ],
                                                        enableObscure: true,
                                                        onChange: (val) {
                                                          cvvCode = val;
                                                        },
                                                        validate: (value) {
                                                          if (value!.isEmpty ||
                                                              value.length <
                                                                  3 ||
                                                              value.length <
                                                                  3) {
                                                            return 'Please enter a valid CVV/CVC';
                                                          }
                                                        },
                                                      )),
                                                ),
                                              ]),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child:
                                                            CustomTextFormField(
                                                          // prefixIcon: AppIcons.profile,
                                                          hintText:
                                                              'Enter your first name',
                                                          label:
                                                              'CardHolder Name',
                                                          controller:
                                                              cardHolderNameController,

                                                          inputFormatter: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    "[a-zA-Z]"))
                                                          ],
                                                          // validator: RequiredValidator(errorText: "asdf"),
                                                          textInputType:
                                                              TextInputType
                                                                  .name,
                                                          maxLength: 29,
                                                          onChange: (val) {
                                                            cardHolderName =
                                                                val;
                                                            // _signUpKey.currentState!.validate();
                                                          },
                                                          validate: (val) {
                                                            if (val == '') {
                                                              return 'This field is mandatory';
                                                            } else if (val!
                                                                    .length >
                                                                30) {
                                                              return 'User Name must be smaller than 30 character';
                                                            }
                                                            return null;
                                                          },
                                                        ))),
                                                // Flexible(
                                                //     child: Padding(
                                                //         padding:
                                                //             const EdgeInsets
                                                //                 .only(left: 10),
                                                //         child:
                                                //             CustomTextFormField(
                                                //           // prefixIcon: AppIcons.profile,
                                                //           label: 'Last Name',
                                                //           hintText:
                                                //               'Enter your last name',
                                                //           maxLength: 29,
                                                //           inputFormatter: [
                                                //             FilteringTextInputFormatter
                                                //                 .allow(RegExp(
                                                //                     "[a-zA-Z]"))
                                                //           ],
                                                //           textInputType:
                                                //               TextInputType
                                                //                   .name,
                                                //           onChange: (val) {
                                                //             lastName = val;
                                                //             // _signUpKey.currentState!.validate();
                                                //           },
                                                //           validate: (val) {
                                                //             if (val == '') {
                                                //               return 'This field is mandatory';
                                                //             } else if (val!
                                                //                     .length >
                                                //                 30) {
                                                //               return 'User Name must be smaller than 30 character';
                                                //             }
                                                //             return null;
                                                //           },
                                                //         )))
                                              ]),
                                          CustomTextFormField(
                                            // prefixIcon: AppIcons.location,
                                            label: 'Zip',
                                            hintText: 'Your zipcode',
                                            textInputType: TextInputType.number,
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]")),
                                              LengthLimitingTextInputFormatter(
                                                  5)
                                            ],
                                            maxLength: 5,
                                            onChange: (val) {
                                              zipCode = val;
                                            },
                                            validate: (val) {
                                              if (val == '') {
                                                return 'This field is mandatory';
                                              }
                                              return null;
                                            },
                                          ),
                                          CustomTextFormField(
                                            // prefixIcon: AppIcons.location,
                                            label: 'Ride Amount',
                                            hintText: 'Enter Amount',
                                            // initialValue: '\$0.00',
                                            showbelowline: true,
                                            textInputType: TextInputType.number,
                                            prefixText: '\$',
                                            // controller: textfieldcontroller,
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                                            ],
                                            maxLength: 5,
                                            onChange: (val) {
                                              if (val != '') {
                                                amount = double.parse(val);
                                                // textfieldcontroller.text =
                                                //     '\$$amount';
                                              }
                                            },
                                            validate: (val) {
                                              if (val == '') {
                                                return 'This field is mandatory';
                                              } else if (amount > 500) {
                                                return 'Limit Exceeded';
                                              }
                                              return null;
                                            },
                                          ),
                                          CustomButton(
                                              label: 'Continue',
                                              onTap: () async {
                                                print(
                                                    "Flutter Module -Clicked! ${formKey.currentState!.validate()}}");
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  print(
                                                      'Flutter Module -RAMAMMAMAMA cardNumber $cardNumber cardHolderName $cardHolderName expiryDate ${int.parse(expiryDate.substring(0, 2))}/${expiryDate.substring(3)} cvvCode $cvvCode');

                                                  generateStripeToken(CardDetails(
                                                      number: cardNumber,
                                                      expirationMonth:
                                                          expiryDate != ""
                                                              ? int.parse(
                                                                  expiryDate
                                                                      .substring(
                                                                          0, 2))
                                                              : 12,
                                                      expirationYear: expiryDate !=
                                                              ""
                                                          ? int.parse(
                                                              "20${expiryDate.substring(3)}")
                                                          : 2025,
                                                      cvc: cvvCode));
                                                } else {
                                                  print(
                                                      'Flutter Module -invalid!');
                                                }
                                              })
                                        ],
                                      )))))));
            })));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void callGetCountryCode(
      String numbers,
      String stripeCardToken,
      num convenienceFee,
      num appCommission,
      num operatorCommission,
      num chargeAmount,
      CardTokenResponse cardTokenResponse) {
    print('Flutter Module -RAMAMAMAMAM callGetCountryCode : $numbers');
    api.users(numbers).then((value) {
      Map<String, dynamic> details = value;
      String countrycode = details['country']['alpha2'].toString();
      print('Flutter Module -RAMAMAMAMAM countrycode : $countrycode');
      var splited = expiryDate.split('/');
      String expMonth = splited.first;
      String expYear = splited.last;
      var cardtype = detectCCType(cardNumber);
      print('Flutter Module -RAMAMMAMAMA amount ${amount}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RideDetails(
                widget.token,
                amount,
                convenienceFee.toDouble(),
                appCommission.toDouble(),
                operatorCommission.toDouble(),
                chargeAmount.toDouble(),
                cardHolderName,
                lastName,
                //New change
                //cardtype.name
                cardtype.first.type,
                countrycode,
                cardNumber,
                cvvCode,
                expMonth,
                expYear,
                zipCode,
                widget.referal,
                widget.myurl,
                stripeCardToken,
                cardTokenResponse)),
      );
    }).catchError((error) {
      print('Flutter Module -Error ${error.toString()}');
      displaydialog(
          context,
          'Payment Failed',
          'Card details entered are invalid. Please enter valid card details and try again.',
          '',
          'Retry',
          1);
      // AppLogger.d(error.toString());
      // displaydialog(context, 'Alert', error.toString(), 1);
      // loading = false;
      // notifyListeners();
    });
  }
}

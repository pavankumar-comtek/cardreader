import 'package:card_sdk/M6pBleControl.dart';
import 'package:flutter/material.dart';
import 'package:card_sdk/M6pBleBean.dart';
import 'package:cardreader/utils/common_scaffold.dart';
import 'package:cardreader/utils/custom_button.dart';
import 'package:cardreader/utils/ui_parameters.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key, required this.deviceName}) : super(key: key);
  final String deviceName;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  BleControl itronBle = BleControl();
  String textStr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    payCardOrICCCard('100', '0356', '0356');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    itronBle.disconnect();
    super.dispose();

  }

  void payCardOrICCCard(String cash, String countryCode, String currencyCode) {
    M6pTradeData tradeData = M6pTradeData();
    // Transaction amount, cents into units
    tradeData.cash = '1200';
    if ((cash != '') && (cash != null)) {
      tradeData.cash = cash;
    }
    // byte1 DUKPT 01    MK/SK  02
    // bytes2 key index  The key algorithm corresponds to the update key index 03
    tradeData.encryptionAlg = "010000000240"; //'020100000200';
    // return data content
    tradeData.sign = "10000004"; //"86640000";  //'CA650000';
    tradeData.transactionInfo = M6pTransactionInfo();
    tradeData.transactionInfo!.countryCode = '0840';
    tradeData.transactionInfo!.currencyCode = '0840';
    if ((currencyCode != '') && (currencyCode != null)) {
      tradeData.transactionInfo!.countryCode = currencyCode;
    }
    if ((countryCode != '') && (countryCode != null)) {
      tradeData.transactionInfo!.currencyCode = countryCode;
    }
    // Transaction Type
    // 00 : Consumption
    tradeData.transactionInfo!.type = '00';
    //subTitle
    tradeData.subTitle = 'Tip ........... \$1.00\n';
    //pan And Valid Input Control
    tradeData.panAndValidInputControl = '010A10600000';
    itronBle.startEmvProcess(60, tradeData, () {
      setState(() {
        textStr = 'Insert Card into Card Reader...';
      });
    }, () {
      setState(() {
        textStr = 'Reading Card Details, Please wait...';
      });
    }, () {
      setState(() {
        textStr = 'Reading NFC Card Details, Please wait...';
      });
    }, (cardInfo, status) {
      String str = '';
      String cardType = '';
      if (cardInfo!.cardType == 1) {
        cardType = "IC Card";
      }
      if (cardInfo.cardType == 0) {
        cardType = "Swipe";
      }
      if (cardInfo.cardType == 2) {
        cardType = "Swipe";
      }
      if ((cardInfo.cardType & 0x03) == 0x03) {
        cardType = "NFC";
      }
      if (cardInfo.cardType == 4) {
        cardType = "Enter";
      }
      if (status == 0) {
        str = 'Consume success\n' +
            'CardNumber:${cardInfo.cardNo!}\n' +
            'CardName:${cardInfo.cardName}\n' +
            'CardType:${cardType}\n' +
            'CardNfcCompany: ${cardInfo.nfcCompany}\n' +
            'cardexpiryDate:${cardInfo.cardexpiryDate}\n' ;
            // 'CardSerial:${cardInfo.cardSerial}\n' +
            // 'CVM:${cardInfo.cvm}\n' +
            // 'ICData:${cardInfo.icdata}\n' +
            // 'TUSN:${cardInfo.tusn}\n' +
            // 'tsn:${cardInfo.tsn}\n' +
            // 'encryTrack:${cardInfo.encryTrack}\n' +
            // 'Tracks:${cardInfo.tracks}\n' +
            // 'TracksLen:${cardInfo.trackLen}\n' +
            // 'OriginalTrack:${cardInfo.originalTrack}\n' +
            // 'OriginalTracklength:${cardInfo.originalTracklength}\n' +
            // 'serviceCode:${cardInfo.serviceCode}\n' +
            // 'batteryLevel:${cardInfo.batteryLevel}\n'


        if (cardInfo.ksn != null) {
          str = str + 'ksn:${cardInfo.ksn}\n';
        }
        if (cardInfo.dataKsn != null) {
          str = str + 'dataKsn:${cardInfo.dataKsn}\n';
        }
        if (cardInfo.trackKsn != null) {
          str = str + 'trackKsn:${cardInfo.trackKsn}\n';
        }
        if (cardInfo.macKsn != null) {
          str = str + 'macKsn:${cardInfo.macKsn}\n';
        }
        if (cardInfo.emvKsn != null) {
          str = str + 'emvKsn:${cardInfo.emvKsn}\n';
        }

        if ((cardInfo.originalTrack != null) &&
            (cardInfo.originalTrack!.length > 0) &&
            (cardInfo.originalTracklength != null) &&
            (cardInfo.originalTracklength!.length > 0)) {
          int track1Len =
              _hexToInt(cardInfo.originalTracklength!.substring(0, 2)) * 2;
          int track2Len =
              _hexToInt(cardInfo.originalTracklength!.substring(2, 4));
          print('track1Len: ${track1Len}  track2Len:${track2Len}');
          if (track1Len > 0) {
            cardInfo.track1 = cardInfo.originalTrack!.substring(0, track1Len);
          }
          if (track2Len > 0) {
            cardInfo.track2 = cardInfo.originalTrack!
                .substring(track1Len, track1Len + track2Len);
          }
          str = str +
              'track1Len: ${track1Len}  track2Len:${track2Len} \n' +
              'cardInfo.track1: ${cardInfo.track1}  \n' +
              'cardInfo.track2: ${cardInfo.track2}';

          print(str);
        }

        //Navigate to Card Payment Screen
      } else {
      //  + status.toRadixString(16)
        str = 'Error Reading Card, Try again after 5 seconds...' ;
        //Error while reading card.
      }
      setState(() {
        textStr = str;
      });

    }, (errorID, msg) {
      setState(() {
        textStr = ' error code: ${errorID} msg: ${msg}';
      });
    }, (errorID, msg, code) {
      setState(() {
        textStr = ' error code: ${errorID} msg: ${msg} data code: ${code}';
      });
    });
  }

  int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: 'Card Reader Check',
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Card Reader Device",
                style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: const RD(d: 24, t: 24, m: 24, s: 24).get(context),
                    color: Color.fromRGBO(69, 100, 130, 1),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('🟢 Connected ',
                      style: TextStyle(
                        color: Color.fromRGBO(85, 221, 87, 1),
                        fontFamily: 'Urbanist-Medium',
                        fontSize: const RD(d: 24, t: 24, m: 18, s: 16).get(context),
                      )),
                  Text(widget.deviceName,
                  style: TextStyle(
                      color: Color.fromRGBO(170, 170, 170, 1),
            fontSize: RD(d:16, t:16, m:16,s:16).get(context)
        ),)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Card Status",
                style: TextStyle(
                    fontFamily: 'Urbanist-Bold',
                    fontSize: const RD(d: 24, t: 24, m: 24, s: 24).get(context),
                    color: Color.fromRGBO(69, 100, 130, 1),
                    fontWeight: FontWeight.w700),
              ),
              Text(textStr,
                  style: TextStyle(
                      fontFamily: 'Urbanist-Bold',
                      fontSize:
                          const RD(d: 22, t: 22, m: 22, s: 22).get(context),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color.fromRGBO(90, 202, 226, 1))),
              Spacer(),
              Center(
                child: CustomButton(
                  label: '(Or) Enter Card Details Manually',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ));
  }
}

import 'dart:convert';
import 'dart:core';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Image avatarImage(String profilePic) {
  if (profilePic == '') {
    return Image.asset('assets/images/sample_avatar.png');
  } else {
    try {
      return Image.memory(base64Decode(profilePic));
    } catch (e) {
      return Image.asset('assets/images/sample_avatar.png');
    }
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

Widget bankCardLogo(String imgString) {
  if (imgString == '') {
    return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Image.asset('assets/images/bank-logo.png',
            fit: BoxFit.fitHeight, height: 10));
  } else {
    return Image.memory(
      base64Decode(imgString),
      fit: BoxFit.fitHeight,
      height: 25,
    );
  }
}

Widget imageLogo(String imgString) {
  if (imgString == '') {
    return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Image.asset('assets/images/bank-logo.png',
            fit: BoxFit.fitHeight, height: 10));
  } else {
    return Image.memory(
      base64Decode(imgString),
      fit: BoxFit.fitHeight,
      // cacheWidth: 50,
      // cacheHeight: 50,
    );
  }
}

backgroundwithRect(
  BuildContext context,
  Center child,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(7),
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration:
          BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1)),
      // height: 30,
      // width: 30,
      child: child,
    ),
  );
}

String bankInfoClientString() {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'apple';
  }
  return '';
}

String lowerCaseAllWordsExceptFirstLetters(String val) {
  return val.substring(0, 1) + val.substring(1).toLowerCase();
}

String removeComma(String text) {
  return text.replaceAll(',', '');
}

String removeDollar(String text) {
  return text.replaceAll('\$', '');
}

String formatCurrency(num value) {
  ArgumentError.checkNotNull(value, 'value');
  // convert cents into hundreds.
  value = value / 100;

  return NumberFormat.currency(
    customPattern: '###,###.##',
  ).format(value);
}

String typedstring(String newValue) {
  // String newText = newValue.text
  String newText = removeDollar(newValue)
      //.replaceAll(SendResourcesScreen._cents, '')
      .replaceAll('.', '')
      .replaceAll(',', '')
      .replaceAll('_', '')
      .replaceAll('-', '');
  String value = newText;
  if (newText.isNotEmpty) {
    value = formatCurrency(double.parse(newText));
  }
  return '\$$value';
}


// String transferToString(TransferType val) {
//   if (val == TransferType.CRYPTO) {
//     return 'WALLET';
//   } else if (val == TransferType.CARD) {
//     return 'CARD';
//   }
//   return '';
// }

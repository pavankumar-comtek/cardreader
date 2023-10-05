import 'dart:math';

String numToString(num? val) {
  String result = '';
  // if (val - val.toInt() != 0) {
  if (val == null) return '';
  result = val.toStringAsFixed(2);
  // } else {
  //   result = val.toString();
  // }
  return result.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
  String value = number.toString();
  try {
    // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
    if (!value.contains('.')) {
      value = '${value.toString()}.00'.toString();
    }
    String numbersAfterDecimal = value.split('.')[1];
    if (numbersAfterDecimal != '0') {
      int existingNumberOfDecimal = numbersAfterDecimal.length;
      number += 1 / (10 * pow(10, existingNumberOfDecimal));
    }

    return double.parse(number.toStringAsFixed(numberOfDecimal));
  } catch (error) {
    print(error);
  }
  return 0.00;
}

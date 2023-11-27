
import 'package:flutter/material.dart';

class ColorConstant {
  static Color bluegray800 = fromHex('#2b3951');
  static Color bluegray600 = fromHex('#456482');
  static Color bluegray400 = fromHex('#7d93a8');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
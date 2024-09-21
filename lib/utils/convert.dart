import 'dart:convert';

class Convert {
  Convert._();

  static String encodeJson(Object object) {
    return jsonEncode(object);
  }

  static String stringToBase64(String str) {
    return base64Encode(utf8.encode(str));
  }
}

class NumberUtils {
  ///parse and format number to display fiat value, currency value...
  static String formatCurrency(num, length) {
    if (length == 2) {
      return (num ?? 0).toStringAsFixed(length).replaceAllMapped(
              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => "${m[1]}.");
    }
    if (length == 0)
      return (num ?? 0).toStringAsFixed(length).replaceAllMapped(
              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => "${m[1]}.");

    //=========================
    String fullStrNumber = (num ?? 0).toStringAsFixed(length);
    String integerPart = fullStrNumber.substring(0, fullStrNumber.indexOf(","));
    String realPart = fullStrNumber.substring(fullStrNumber.indexOf((",")) + 1);
    integerPart = integerPart.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");

    return integerPart + "." + realPart;
  }

  /// check a string is number or not
  static bool isNumeric(String str) {
    try {
      double.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }
}

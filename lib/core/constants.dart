import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Constants {
  // static final numberFormat = NumberFormat('###,##0.00');
  // static final integerFormat = NumberFormat('###,##0');
  static final dateFormat = DateFormat('dd/MM/yyyy');
  static final decimalFormat =
      NumberFormat.decimalPatternDigits(decimalDigits: 2);
  static final phoneFormatter = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  static final cedulaFormatter = MaskTextInputFormatter(
    mask: '###-#######-#',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // THEME VARIABLES
  static final appFont = GoogleFonts.montserrat().fontFamily;
  static const bodyPadding = EdgeInsets.all(10);
  static const scaffoldColor = Color(0XFF0B0E11);
  static const cardColor = Color(0XFF1E2329);
  static const indicatorColor = Color(0XFFFCD535);
  static const darkIndicatorColor = Color(0XFFF0B90B);
  static const secondaryColor = Color(0XFF333b46);
  static const red = Color(0XFFf5465d);
  static const blue = Color(0XFF1773ec);
  static const green = Color(0XFF2ebd85);
  static const grey = Color(0XFFEAECEF);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.controller,
    this.focusNode,
    this.width,
    this.height,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters = const [],
    this.onSubmitted,
    this.inputAction,
    this.isObscure = false,
    this.autofocus = false,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.enabled = true,
    this.autocorrect = true,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? width;
  final double? height;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final TextInputAction? inputAction;
  final int minLines;
  final int maxLines;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter> inputFormatters;
  final void Function(String?)? onSubmitted;
  final bool isObscure;
  final bool autofocus;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry padding;
  final bool enabled;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: TextField(
          autocorrect: autocorrect,
          enabled: enabled,
          autofocus: autofocus,
          obscureText: isObscure,
          onSubmitted: onSubmitted,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          keyboardType: textInputType,
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          focusNode: focusNode,
          textInputAction: inputAction,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            isDense: true,
            labelText: labelText,
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: getSuffixIcon(),
          ),
          onChanged: onChanged,
        ));
  }

  Widget? getSuffixIcon() {
    return errorText == null ? suffixIcon : _CustomErrorIcon(error: errorText!);
  }
}

class _CustomErrorIcon extends StatelessWidget {
  const _CustomErrorIcon({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: error,
      child: const Icon(
        Icons.warning_rounded,
        color: Colors.red,
        size: 25,
      ),
    );
  }
}

class NumericInput extends StatelessWidget {
  const NumericInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.inputAction = TextInputAction.next,
    this.isIntegerField = false,
    this.height,
    this.isDense = false,
    this.onChanged,
  });

  /// TextEditingController del textfield
  final TextEditingController? controller;

  /// FocusNode del textfield
  final FocusNode? focusNode;

  /// Ícono que tendrá el textfield en la izquierda
  final Widget? prefixIcon;

  /// Ícono que tendrá el textfield en la derecha
  final Widget? suffixIcon;

  /// Texto flotante del textfield
  final String? labelText;

  /// Acción a mostrar en el botón de acción del teclado
  final TextInputAction inputAction;

  /// Establecer este booleano a true si textfield numérico es de tipo entero
  final bool isIntegerField;

  /// Alto que tendrá el textfield, por defecto va a tomar el alto que tiene predefinido el textfield
  final double? height;

  /// Establecer este booleano a true si se desea condensar el alto del textfield
  final bool isDense;

  /// Callback que se ejecutará cada vez que se haga un cambio en el textfield
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onFocusChange: (bool hasFocus) {
        if (hasFocus) {
          controller?.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller?.text.length ?? 0,
          );
          return;
        }
        final format = isIntegerField
            ? NumberFormat('###,##0')
            : NumberFormat('###,##0.00');
        controller?.text = format.format(
          double.tryParse(controller?.text.replaceAll(',', '') ?? '0') ?? 0.0,
        );
      },
      child: CustomInput(
        height: height,
        controller: controller,
        focusNode: focusNode,
        prefixIcon: prefixIcon,
        labelText: labelText,
        inputAction: inputAction,
        onChanged: onChanged,
        textInputType: TextInputType.numberWithOptions(
          decimal: !isIntegerField,
          signed: false,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

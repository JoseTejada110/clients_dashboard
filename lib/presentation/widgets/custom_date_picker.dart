import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/constants.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.value,
    required this.onDatePicked,
    this.labelText,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  });
  final DateTime? value;
  final void Function(DateTime) onDatePicked;
  final String? labelText;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.dialog(
          _CupertinoDatePicker(
            onDatePicked: onDatePicked,
            initialDateTime: initialDateTime,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
          ),
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          isDense: true,
          labelText: labelText,
        ),
        child: Text(
          value == null ? '' : Constants.dateFormat.format(value!),
        ),
      ),
    );
  }
}

class _CupertinoDatePicker extends StatelessWidget {
  const _CupertinoDatePicker({
    Key? key,
    required this.onDatePicked,
    required this.initialDateTime,
    required this.minimumDate,
    required this.maximumDate,
  }) : super(key: key);
  final void Function(DateTime) onDatePicked;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_CustomDatePickerController());
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text('Seleccionar una fecha'),
              ),
              const Divider(),
              SizedBox(
                height: 200,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CupertinoDatePicker(
                    initialDateTime: initialDateTime,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: controller.pickDate,
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    onDatePicked(controller.pickedDate.value);
                    Get.back();
                  },
                  child: const Text('Confirmar'),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}

class _CustomDatePickerController extends GetxController {
  _CustomDatePickerController();

  Rx<DateTime> pickedDate = DateTime.now().obs;

  void pickDate(DateTime date) => pickedDate.value = date;
}

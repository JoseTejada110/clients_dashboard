import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_controller.dart';

class CreateTransferPage extends GetView<CreateTransferController> {
  const CreateTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacer Transferencia'),
      ),
      body: const Center(
        child: Text('Hacer Transferencia'),
      ),
    );
  }
}

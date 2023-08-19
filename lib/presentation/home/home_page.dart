import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/presentation/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: controller.getHomeChildren(),
      ),
      bottomNavigationBar: const _BottomMenu(),
    );
  }
}

//Menú personalizado
class _BottomMenu extends GetView<HomeController> {
  const _BottomMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: Constants.scaffoldColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.currentIndex.value,
        selectedItemColor: Constants.darkIndicatorColor,
        unselectedItemColor: Constants.grey,
        items: controller.getMenuItems(),
        onTap: (int newIndex) => controller.updateMenuIndex(newIndex),
      ),
    );
  }
}

import 'package:get/get.dart';

class LayoutController extends GetxController {
  final isSidebarExpanded = true.obs;

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
  }
}

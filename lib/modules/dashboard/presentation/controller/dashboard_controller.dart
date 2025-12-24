import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 2.obs; // Default to Home (Index 2)

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}

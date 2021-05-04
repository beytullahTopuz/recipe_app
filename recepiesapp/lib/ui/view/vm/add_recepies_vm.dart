import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddRecepiesVM extends GetxController {
  var mList = RxList<String>();
  // RxString strmalzemeler;

  malzemeEkle(String m) {
    mList.add(m);
  }

  String malzemeYazdir() {
    String temp = "";
    if (mList != null) {
      for (int i = 0; i < mList.length; i++) {
        temp += "\n- ${mList[i]}";
      }
    }
    return temp;
  }
}

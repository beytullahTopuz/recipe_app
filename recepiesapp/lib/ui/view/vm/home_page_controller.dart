import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:recepiesapp/core/models/food.dart';
import 'package:recepiesapp/core/services/my_firestore_service.dart';

class HomePageController extends GetxController {
  var foodlist = RxList<Food>();

  HomePageController() {
    getAllFood();
  }

  getAllFood() async {
    foodlist.addAll(await MyFireStoreServisi().getAllFood());

    return foodlist;
  }

  addFood(Food food) {
    try {
      MyFireStoreServisi().addFood(food);
      foodlist.add(food);
    } catch (e) {
      print(e.code());
    }
  }
}

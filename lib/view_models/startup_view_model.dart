import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/services/redis_services.dart';
import 'package:smart_pos/utils/share_pref.dart';
import 'package:smart_pos/view_models/index.dart';

import '../utils/request.dart';
import '../utils/routes_constraints.dart';

class StartUpViewModel extends Model {
  RedisService service = RedisService();
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    await service.setDataToRedis();
    // await service.sendDataToRedis("products", 0);
    // service.getDataFromRedis("products");
    await Future.delayed(const Duration(seconds: 1));
    String? token = await getToken();
    if (token != null) {
      requestObj.setToken = token;
      await Get.find<MenuViewModel>().getMenuOfStore();
      await Get.find<CartViewModel>().getListPromotion();
      Get.offNamed(RouteHandler.HOME);
    } else {
      Get.offNamed(RouteHandler.LOGIN);
    }
  }
}

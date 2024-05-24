import 'package:flutter/foundation.dart';
import 'package:smart_pos/models/login_model.dart';
import 'package:smart_pos/services/request_pointify.dart';

import '../models/account_model.dart';
import '../models/customer.dart';
import '../utils/request.dart';
import '../utils/share_pref.dart';

class AccountServices {
  Future<AccountModel?> login(LoginModel login) async {
    try {
      dynamic response = await request.post("auth/login",
          data: {"username": login.username, "password": login.password});
      if (response.statusCode?.compareTo(200) == 0) {
        final user = response.data;
        AccountModel userResponse = AccountModel.fromJson(user);
        final accessToken = user['accessToken'] as String;
        requestObj.setToken = accessToken;
        setToken(accessToken);
        if (userResponse.storeId != null) {
          await setStoreId(userResponse.storeId!);
        }
        return userResponse;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error login (account_dao): ${e.toString()}');
      }
    }
    return null;
  }

  Future<CustomerInfoModel?> scanCustomer(String phone) async {
    print(phone);
    var storeId = await getStoreId();
    final response = await requestPointify
        .get("stores/$storeId/scan-user", queryParameters: {"code": phone});

    if (response.statusCode == 200) {
      final customer = response.data;

      CustomerInfoModel customerInfoModel =
          CustomerInfoModel.fromJson(customer);
      return customerInfoModel;
    } else {
      return null;
    }
  }
}

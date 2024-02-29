import 'package:flutter/foundation.dart';
import 'package:smart_pos/models/login_model.dart';

import '../models/account_model.dart';
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
}

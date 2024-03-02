import 'dart:async';
import 'package:redis/redis.dart';

class RedisService {
  RedisConnection conn = RedisConnection();
  Future<void> setDataToRedis(String key, String value) async {
    // client = await RedisClient.connect('localhost');
    print("start to set data to redis");
    await conn.connect('localhost', 6379).then((Command command) {
      command.send_object(["SET", key, value]).then(
          (dynamic response) => print(response));
    });
  }

  Future<dynamic> getDataFromRedis(String key) async {
    print("start to get data from redis");
    Command command = await conn.connect('localhost', 6379);
    var res = await command.send_object(["GET", key]);
    return res;
  }
}

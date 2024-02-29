import 'dart:async';
import 'dart:convert';

import 'package:redis/redis.dart';
import 'package:dio/dio.dart';
import 'package:redis_dart/redis_dart.dart';

class RedisService {
  // Variables
  final connection = RedisConnection();
  final dio = Dio();
  // init() async {
  //   connection.connect('localhost', 6379).then((Command command) {
  //     print(command);
  //     command.send_object(["SET", "key", "0"]);
  //   });
  // }
  RedisClient? client;

  Future<void> setDataToRedis() async {
    client = await RedisClient.connect('localhost:6379');
    await client?.set('name', 'Gabriel');

    var res = await client?.get('name');
    print(res);

    // await client.close();
  }

  Future<void> sendDataToRedis(String key, dynamic value) async {
    // List<Map<String, dynamic>> list = [
    //   ProductScanModel(code: "ADAS", quantity: 1).toJson(),
    //   ProductScanModel(code: "ASDAD", quantity: 2).toJson()
    // ];
    // if (kDebugMode) {
    //   print(list);
    // }
    final response = await dio.post('http://localhost:3000/send',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(<String, dynamic>{
          'key': key,
          'value': value,
        }));

    // final response = await http.post(
    //   Uri.parse(
    //       'http://localhost:3000/send'), // Update with your server's address
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'key': key,
    //     'value': value,
    //   }),
    // );

    if (response.statusCode == 200) {
      print('Data successfully sent to Redis');
    } else {
      print('Failed to send data to Redis: ${response.data}');
    }
  }

  Future<void> getDataFromRedis(String key) async {
    final response = await dio.get(
      'http://localhost:3000/get/$key',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );
    print(jsonDecode(response.data));

    // print(list);
    if (response.statusCode == 200) {
      print('Data successfully get from Redis');
    } else {
      print('Failed to send data to Redis: ${response.data}');
    }
  }
}

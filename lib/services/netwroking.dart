import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  // Future getWeatherData() async {
  //   try {
  //     http.Response response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       String data = response.body;

  //       return jsonDecode(data);
  //     } else {
  //       switch (response.statusCode) {
  //         case 100:
  //           return Fluttertoast.showToast(msg: "100 Continue");
  //         case 300:
  //           return Fluttertoast.showToast(msg: "300 Multiple Choices redirect");
  //         case 400:
  //           return Fluttertoast.showToast(msg: "400 Bad Request");
  //         case 500:
  //           return Fluttertoast.showToast(msg: "500 Internal Server Error");
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future fetchCategories() async {
  final dio = Dio();

  try {
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          "Accept": "application/json",
        },
      ),
    );

    return response.data;
  } catch (e) {
    debugPrint(e.toString());
  }
}
}

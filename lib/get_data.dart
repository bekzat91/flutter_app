import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:test_task/models/spare_part_model.dart';

//Potential server data
class GetData {
  List<SparePartModel> finalList = [];

  //example data from server
  String data = '''
  [{
      "brand": "Toyota",
      "amount": 840,
      "original": true,
      "part_num": "SF680F4079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "BMW",
      "amount": 2550,
      "original": true,
      "part_num": "SF680F4079",
      "top": false,
      "vcurrency": "KZT"
    },
    {
      "brand": "Toyota",
      "amount": 23450,
      "original": true,
      "part_num": "SF680F4079",
      "top": false,
      "vcurrency": "KZT"
    }]
  ''';

  List<SparePartModel> getDataFromServer() {
    late final dbList;
    try {
      final dynamic jsonString = jsonDecode(data) as List;
      dbList =
          jsonString.map((dynamic e) => SparePartModel.fromJson(e)).toList();

      //
    } catch (error) {
      print('error found $error');
    }
    return dbList;
  }

  void decode() {
    try {
      final dynamic jsonString = jsonDecode(data) as List;
      final dbList =
          jsonString.map((dynamic e) => SparePartModel.fromJson(e)).toList();
    } catch (error) {
      print('error found $error');
    }
  }
}

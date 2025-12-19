import 'dart:developer';
import 'package:yegnabet/model/home_madel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  bool isError = false;
  bool socketExc = false;
  bool unautorized = false;
  String? errorMessage = '';

  HomeModel? homeModel;
  Datum? detailModel;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      final String jsonString = await rootBundle.loadString('assets/files/data.json');
      homeModel = HomeModel.fromRawJson(jsonString);
    } catch (e) {
      log("Error loading houses: $e");
    } finally {
      isLoading = false;
    }
    update();
  }

  Future<void> fetchDetail(Datum detailData) async {
    try {
      isLoading = true;
      detailModel = detailData;
    } catch (e) {
      log("Error loading houses: $e");
    } finally {
      isLoading = false;
    }
    update();
  }
}

import 'package:dakshattendance/AppConst/AppConst.dart';
import 'package:dakshattendance/Model/ProfileModel.dart';
import 'package:dakshattendance/Model/ProfileModel.dart';
import 'package:dakshattendance/Model/WorkingFor.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EmployeeInfoProvider extends ChangeNotifier {
  String tag = 'EmployeeInfoProvider';

  ProfileData? profileData;
  bool loadingProfileData = false;

  Future<void> getProfileData() async {
    var response;
    try {
      loadingProfileData = true;
      notifyListeners();
      Map<String, String> headers = {"Accept": "*/*"};
      var url = AppConst.baseUrl + AppConst.edit_profile + 'emp_id=1';
      bool cacheExist =
          await APICacheManager().isAPICacheKeyExist('profileData');
      notifyListeners();
      var res = await http.get(Uri.parse(url), headers: headers);
      // // debugPrint(
      //     '$tag getProfileData response ${res.request!.url} ${res.body}');
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == 'Success') {
          var data = jsonDecode(res.body)['data'];
          var cacheModel =
              APICacheDBModel(key: 'profileData', syncData: jsonEncode(data));
          await APICacheManager().addCacheData(cacheModel);
          response = cacheModel.syncData;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      }
      // // debugPrint("it's url getProfileData Hit  $response ");
      // } else {
      //   showNetWorkToast();
      //   if (cacheExist) {
      //     response =
      //         (await APICacheManager().getCacheData('profileData')).syncData;
      // //     debugPrint("it's getProfileData cache Hit $response");
      //   }
      // }
      response = jsonDecode(response);
      if (response != null) {
        profileData = (ProfileData.fromJson(response));

        notifyListeners();
      }

      // // debugPrint('$tag getProfileData total ${profileData!.toJson()}');
    } catch (e) {
      // // debugPrint('e e e e e  getProfileData e e -> $e');
    }
    // // debugPrint('testing getProfileData ------ >getVehicles ');
    loadingProfileData = false;
    notifyListeners();
  }

  bool loadingStates = false;
  List<String> states = [];
  Future<void> getStates() async {
    var response;
    try {
      loadingStates = true;
      notifyListeners();
      Map<String, String> headers = {"Accept": "*/*"};
      var url = AppConst.baseUrl + 'master.php?func_name=get_states';
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('states');
      notifyListeners();
      var res = await http.get(Uri.parse(url), headers: headers);
      // debugPrint('$tag getStates response ${res.request!.url} ${res.body}');
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == 'Success') {
          var data = jsonDecode(res.body)['data'];
          var cacheModel =
              APICacheDBModel(key: 'states', syncData: jsonEncode(data));
          await APICacheManager().addCacheData(cacheModel);
          response = cacheModel.syncData;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      }
      // debugPrint("it's url getStates Hit  $response ");
      response = jsonDecode(response);
      // debugPrint('$tag getStates total ${response} ${response.runtimeType}');
      states.clear();

      if (response != null && response is List) {
        states = List<String>.from(response);
        notifyListeners();
      }

      // debugPrint('$tag getStates total ${states.length}');
    } catch (e) {
      // debugPrint('e e e e e  getStates e e -> $e');
    }
    // debugPrint('testing getStates ------ >getStates ');
    loadingStates = false;
    notifyListeners();
  }

  ///principal Companies
  bool loadingCompanies = false;
  List<String> principalCompanies = [];
  Future<void> getPrincipalCompanies() async {
    var response;
    try {
      loadingCompanies = true;
      notifyListeners();
      Map<String, String> headers = {"Accept": "*/*"};
      var url =
          AppConst.baseUrl + 'master.php?func_name=get_principal_companies';
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('companies');
      notifyListeners();
      var res = await http.get(Uri.parse(url), headers: headers);
      // // debugPrint(
      //     '$tag getPrincipalCompanies response ${res.request!.url} ${res.body}');
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == 'Success') {
          var data = jsonDecode(res.body)['data'];
          var cacheModel =
              APICacheDBModel(key: 'companies', syncData: jsonEncode(data));
          await APICacheManager().addCacheData(cacheModel);
          response = cacheModel.syncData;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      }
      // debugPrint("it's url getPrincipalCompanies Hit  $response ");
      response = jsonDecode(response);
      // debugPrint(
      //     '$tag getPrincipalCompanies total ${response} ${response.runtimeType}');
      principalCompanies.clear();
      if (response != null && response is List) {
        principalCompanies = List<String>.from(response);
        notifyListeners();
      }

      // debugPrint(
      //     '$tag getPrincipalCompanies total ${principalCompanies.length}');
    } catch (e) {
      // debugPrint('e e e e e  getPrincipalCompanies e e -> $e');
    }
    // debugPrint('testing getPrincipalCompanies ------ >getPrincipalCompanies ');
    loadingCompanies = false;
    notifyListeners();
  }

  ///working for
  bool loadingWorkingFor = false;
  List<WorkingForModel> workingForCompanies = [];
  Future<void> getWorkingFor() async {
    var response;
    try {
      loadingWorkingFor = true;
      notifyListeners();
      Map<String, String> headers = {"Accept": "*/*"};
      var url =
          AppConst.baseUrl + 'master.php?func_name=get_company_working_for';
      bool cacheExist =
          await APICacheManager().isAPICacheKeyExist('workingFor');
      notifyListeners();
      var res = await http.get(Uri.parse(url), headers: headers);
      debugPrint('$tag getWorkingFor response ${res.request!.url} ${res.body}');
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == 'Success') {
          var data = jsonDecode(res.body)['data'];
          var cacheModel =
              APICacheDBModel(key: 'workingFor', syncData: jsonEncode(data));
          await APICacheManager().addCacheData(cacheModel);
          response = cacheModel.syncData;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      }
      // debugPrint("it's url getWorkingFor Hit  $response ");
      response = jsonDecode(response);
      // debugPrint(
      //     '$tag getWorkingFor total ${response} ${response.runtimeType}');
      if (response != null) {
        // debugPrint(
        //     '$tag getWorkingFor total response ${response.length} ${response.runtimeType}');

        List<Map<String, dynamic>>.from(response).forEach((element) {
          print(element);
          try {
            workingForCompanies.add(WorkingForModel.fromJson(element));
          } catch (e) {
            print('e $e');
          }
        });
        notifyListeners();
      }
      // debugPrint('$tag getWorkingFor total ${workingForCompanies.length}');
    } catch (e) {
      // debugPrint('e e e e e  getWorkingFor e e -> $e');
    }
    // debugPrint('testing getWorkingFor ------ >getWorkingFor ');
    loadingWorkingFor = false;
    notifyListeners();
  }

  ///working for
  bool loadingZones = false;
  List<String> zones = [];
  Future<void> getZones() async {
    var response;
    try {
      loadingZones = true;
      notifyListeners();
      Map<String, String> headers = {"Accept": "*/*"};
      var url = AppConst.baseUrl +
          'master.php?func_name=get_zones&working_for=YJ FOODS PRIVATE LIMITED';
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('zones');
      notifyListeners();
      var res = await http.get(Uri.parse(url), headers: headers);
      debugPrint('$tag getZones response ${res.request!.url} ${res.body}');
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == 'Success') {
          var data = jsonDecode(res.body)['data'];
          var cacheModel =
              APICacheDBModel(key: 'zones', syncData: jsonEncode(data));
          await APICacheManager().addCacheData(cacheModel);
          response = cacheModel.syncData;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      }
      // debugPrint("it's url getWorkingFor Hit  $response ");
      response = jsonDecode(response);
      debugPrint('$tag getZones total ${response} ${response.runtimeType}');
      if (response != null) {
        zones.clear();
        response.forEach((element) {
          zones.add(element['zone_nm']);
        });
        notifyListeners();
      }
      debugPrint('$tag getZones total ${zones.length}');
    } catch (e) {
      debugPrint('e e e e e  getWorkingFor e e -> $e');
    }
    // debugPrint('testing getWorkingFor ------ >getWorkingFor ');
    loadingZones = false;
    notifyListeners();
  }

  ///Step 2
  List<List> fieldControl = [];
  List<SingleValueDropDownController> controllers = [];
}

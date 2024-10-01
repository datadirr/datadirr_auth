import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:flutter_dropdown_plus/dropdown_item.dart';

class Gender {
  String genderId;
  String genderName;

  Gender({this.genderId = "", this.genderName = ""});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
        genderId: json['genderId'] ?? "", genderName: json['genderName'] ?? "");
  }

  static fromJsonToList(dynamic list) {
    return (list ?? []).map<Gender>((json) => Gender.fromJson(json)).toList();
  }

  static Future<List<Gender>> genders() async {
    List<Gender> auths = [];
    dynamic res = await Api.request(cName: Api.cGender, fName: Api.fGenders);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auths = Gender.fromJsonToList(Api.result(res)["gender"]);
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auths;
  }

  static Future<List<DropdownItem>> dropdownGender() async {
    List<DropdownItem> list = [];
    List<Gender> genderList = await genders();
    for (Gender gender in genderList) {
      list.add(DropdownItem(id: gender.genderId, value: gender.genderName));
    }
    return list;
  }
}

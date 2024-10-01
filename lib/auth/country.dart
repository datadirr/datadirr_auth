import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:flutter_widget_function/function/utils.dart';

class Country {
  String countryId;
  String countryName;
  String countryPhoneCodePlus;
  String countryPhoneCode;
  String countryCodeISO2;
  String countryCodeISO3;
  bool selected;

  Country(
      {this.countryId = "",
      this.countryName = "",
      this.countryPhoneCodePlus = "",
      this.countryPhoneCode = "",
      this.countryCodeISO2 = "",
      this.countryCodeISO3 = "",
      this.selected = false});

  factory Country.fromJson(Map<String, dynamic> json, {Country? country}) {
    String countryId = json['countryId'] ?? "";
    bool selected = false;
    if (country != null) {
      if (Utils.equals(country.countryId, countryId)) {
        selected = true;
      }
    }
    return Country(
        countryId: countryId,
        countryName: json['countryName'] ?? "",
        countryPhoneCodePlus: json['countryPhoneCodePlus'] ?? "",
        countryPhoneCode: json['countryPhoneCode'] ?? "",
        countryCodeISO2: json['countryCodeISO2'] ?? "",
        countryCodeISO3: json['countryCodeISO3'] ?? "",
        selected: selected);
  }

  static fromJsonToList(dynamic list, {Country? country}) {
    return (list ?? [])
        .map<Country>((json) => Country.fromJson(json, country: country))
        .toList();
  }

  static Future<List<Country>> countries({Country? country}) async {
    List<Country> auths = [];
    dynamic res = await Api.request(cName: Api.cCountry, fName: Api.fCountries);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auths = Country.fromJsonToList(Api.result(res)["country"],
              country: country);
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auths;
  }
}

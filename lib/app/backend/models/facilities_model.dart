/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
class FacilitiesModel {
  int? id;
  String? name;
  // int? status;

  FacilitiesModel({
    this.id,
    this.name,
    // this.status,
  });

  FacilitiesModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    //cityId = int.parse(json['city_id'].toString());
    name = json['name'];

    // status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    // data['status'] = status;
    return data;
  }
}

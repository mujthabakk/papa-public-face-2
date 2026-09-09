/*Papabear*/
class SupportModel {
  int? id;
  String? firstName;
  String? lastName;

  SupportModel({this.id, this.firstName, this.lastName});

  SupportModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    firstName = json['first_name']?.toString() ?? 'Support';
    lastName = json['last_name']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

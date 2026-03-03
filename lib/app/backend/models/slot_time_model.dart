class SlotTimeModel {
  String? startTime;
  String? endTime;
  String? available; // Added this field as it's in your JSON

  SlotTimeModel({this.startTime, this.endTime, this.available});

  SlotTimeModel.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    available = json['available']; // Parse available field
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['available'] = available;
    return data;
  }
}

class CashbackSetting {
  final int id;
  final String userType;
  final double percentage;
  final int status;

  CashbackSetting({
    this.id = 0,
    this.userType = '',
    this.percentage = 0,
    this.status = 0,
  });

  bool get isActive => status == 1 && percentage > 0;

  factory CashbackSetting.fromJson(Map<String, dynamic> json) {
    return CashbackSetting(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userType: json['user_type']?.toString() ?? '',
      percentage: double.tryParse(json['percentage']?.toString() ?? '') ?? 0,
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
    );
  }
}

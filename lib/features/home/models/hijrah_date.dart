class HijrahDateModel {
  final String holiday;
  final String currentDate;
  final String currentDay;
  final String currentHijrahDate;

  HijrahDateModel({
    required this.holiday,
    required this.currentDate,
    required this.currentDay,
    required this.currentHijrahDate,
  });

  factory HijrahDateModel.fromJson(Map<String, dynamic> json) {
    return HijrahDateModel(
      holiday: json['holiday'] ?? '',
      currentDate: json['currentDate'] ?? '',
      currentDay: json['currentDay'] ?? '',
      currentHijrahDate: json['currentHijrahDate'] ?? '',
    );
  }

  factory HijrahDateModel.setNull() {
    return HijrahDateModel(
      holiday: '',
      currentDate: '',
      currentDay: '',
      currentHijrahDate: '',
    );
  }
}

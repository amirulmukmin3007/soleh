class ZikirHarianModel {
  final String title;
  final String imageUrl;
  final int day;
  final String dayName;

  ZikirHarianModel({
    required this.title,
    required this.imageUrl,
    required this.day,
    required this.dayName,
  });

  factory ZikirHarianModel.fromJson(Map<String, dynamic> json) {
    return ZikirHarianModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      day: json['day'],
      dayName: json['dayName'],
    );
  }

  factory ZikirHarianModel.setNull() {
    return ZikirHarianModel(
      title: '',
      imageUrl: '',
      day: 0,
      dayName: '',
    );
  }
}

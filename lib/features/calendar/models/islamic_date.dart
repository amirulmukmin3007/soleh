class IslamicDate {
  final DateTime englishDate; // for calendar logic
  final String hijrahDate; // display only
  final String occasion;

  IslamicDate({
    required this.englishDate,
    required this.hijrahDate,
    required this.occasion,
  });

  factory IslamicDate.fromMap(Map<String, dynamic> json) {
    return IslamicDate(
      englishDate: DateTime.parse(json['english_date']),
      hijrahDate: json['hijrah_date'],
      occasion: json['occasion'],
    );
  }
}

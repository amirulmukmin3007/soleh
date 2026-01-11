class PinModel {
  final double latitude;
  final double longitude;

  PinModel({required this.latitude, required this.longitude});

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

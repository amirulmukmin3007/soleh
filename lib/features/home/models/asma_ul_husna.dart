class AsmaUlHusnaModel {
  final String auhMeaning;
  final String auhAR;
  final String auhEN;
  final String auhNum;

  AsmaUlHusnaModel({
    required this.auhMeaning,
    required this.auhAR,
    required this.auhEN,
    required this.auhNum,
  });

  factory AsmaUlHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaModel(
      auhMeaning: json['meaning'],
      auhAR: json['ar'],
      auhEN: json['en'],
      auhNum: json['num'],
    );
  }

  factory AsmaUlHusnaModel.setNull() {
    return AsmaUlHusnaModel(
      auhMeaning: '',
      auhAR: '',
      auhEN: '',
      auhNum: '',
    );
  }
}

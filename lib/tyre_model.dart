class TyreModel {
  final String? tyrePressure;
  final String? temperature;
  final bool? isLow;
  TyreModel({this.tyrePressure, this.temperature, this.isLow});
}

final List<TyreModel> tyreList = [
  TyreModel(tyrePressure: "23.6", temperature: "56", isLow: true),
  TyreModel(tyrePressure: "35.0", temperature: "41", isLow: false),
  TyreModel(tyrePressure: "34.6", temperature: "41", isLow: false),
  TyreModel(tyrePressure: "34.8", temperature: "42", isLow: false),
];

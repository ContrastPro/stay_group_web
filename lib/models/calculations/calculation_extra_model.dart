class CalculationExtraModel {
  const CalculationExtraModel({
    required this.id,
    required this.name,
    required this.priceVal,
    required this.pricePct,
    required this.date,
  });

  factory CalculationExtraModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationExtraModel(
      id: json['id'],
      name: json['name'],
      priceVal: json['priceVal'],
      pricePct: json['pricePct'],
      date: DateTime.parse(json['date']),
    );
  }

  final String id;
  final String name;
  final String priceVal;
  final String pricePct;
  final DateTime date;

  CalculationExtraModel copyWith({
    String? id,
    String? name,
    String? priceVal,
    String? pricePct,
    DateTime? date,
  }) {
    return CalculationExtraModel(
      id: id ?? this.id,
      name: name ?? this.name,
      priceVal: priceVal ?? this.priceVal,
      pricePct: pricePct ?? this.pricePct,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'priceVal': priceVal,
        'pricePct': pricePct,
        'date': date.toString(),
      };
}

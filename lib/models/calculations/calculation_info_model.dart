class CalculationInfoModel {
  const CalculationInfoModel({
    this.companyId,
    this.projectId,
    this.section,
    this.floor,
    this.number,
    this.type,
    this.rooms,
    this.bathrooms,
    this.total,
    this.living,
    required this.name,
    this.description,
    required this.currency,
    this.price,
    this.depositVal,
    this.depositPct,
    this.period,
    this.startInstallments,
    this.endInstallments,
  });

  factory CalculationInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationInfoModel(
      companyId: json['companyId'],
      projectId: json['projectId'],
      section: json['section'],
      floor: json['floor'],
      number: json['number'],
      type: json['type'],
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      total: json['total'],
      living: json['living'],
      name: json['name'],
      description: json['description'],
      currency: json['currency'],
      price: json['price'],
      depositVal: json['depositVal'],
      depositPct: json['depositPct'],
      period: json['period'],
      startInstallments: json['startInstallments'],
      endInstallments: json['endInstallments'],
    );
  }

  final String? companyId;
  final String? projectId;
  final String? section;
  final String? floor;
  final String? number;
  final String? type;
  final String? rooms;
  final String? bathrooms;
  final String? total;
  final String? living;
  final String name;
  final String? description;
  final String currency;
  final String? price;
  final String? depositVal;
  final String? depositPct;
  final int? period;
  final String? startInstallments;
  final String? endInstallments;
}

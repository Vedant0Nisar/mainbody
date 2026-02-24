class ContractorModel {
  final String id;
  final String name;
  final String phone;

  ContractorModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory ContractorModel.fromJson(Map<String, dynamic> json) {
    return ContractorModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

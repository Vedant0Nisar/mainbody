class ContractorModel {
  final String id;
  final String name;
  final String? email;

  ContractorModel({
    required this.id,
    required this.name,
    this.email,
  });

  factory ContractorModel.fromJson(Map<String, dynamic> json) {
    return ContractorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

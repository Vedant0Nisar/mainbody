import 'contractor_model.dart';
import 'status_enum.dart';

class DefectModel {
  final String id;
  final String location;
  final DateTime createdDate;
  TicketStatus status;
  final String priority;
  final String description;
  final String inspectorName;
  final String beforePhotoUrl;
  final double latitude;
  final double longitude;

  ContractorModel? contractor;
  String? afterPhotoUrl;

  DefectModel({
    required this.id,
    required this.location,
    required this.createdDate,
    required this.status,
    required this.priority,
    required this.description,
    required this.inspectorName,
    required this.beforePhotoUrl,
    required this.latitude,
    required this.longitude,
    this.contractor,
    this.afterPhotoUrl,
  });

  factory DefectModel.fromJson(Map<String, dynamic> json) {
    return DefectModel(
      id: json['id'],
      location: json['location'],
      createdDate: DateTime.parse(json['createdDate']),
      status: TicketStatusExtension.fromString(json['status']),
      priority: json['priority'],
      description: json['description'],
      inspectorName: json['inspectorName'],
      beforePhotoUrl: json['beforePhotoUrl'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      contractor: json['contractor'] != null
          ? ContractorModel.fromJson(json['contractor'])
          : null,
      afterPhotoUrl: json['afterPhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'createdDate': createdDate.toIso8601String(),
      'status': status.name,
      'priority': priority,
      'description': description,
      'inspectorName': inspectorName,
      'beforePhotoUrl': beforePhotoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'contractor': contractor?.toJson(),
      'afterPhotoUrl': afterPhotoUrl,
    };
  }
}

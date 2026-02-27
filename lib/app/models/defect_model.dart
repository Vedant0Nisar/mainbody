import 'status_enum.dart';

class DefectModel {
  final String id;
  final String title;
  final String description;
  final String beforePhotoUrl;
  final String? afterPhotoUrl;
  String? contractorName;
  TicketStatus status;
  final double latitude;
  final double longitude;
  final DateTime createdDate;

  // Additional fields for local UI representation
  final String location;
  final String priority;
  bool isNewlyAdded;

  DefectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.contractorName,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdDate,
    this.location = 'Unknown Location',
    this.priority = 'Normal',
    this.isNewlyAdded = false,
  });

  factory DefectModel.fromJson(Map<String, dynamic> json) {
    return DefectModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'Defect Ticket',
      description: json['description'] ?? '',
      beforePhotoUrl: json['beforePhoto'] ?? json['beforePhotoUrl'] ?? '',
      afterPhotoUrl: json['afterPhoto'] ?? json['afterPhotoUrl'],
      contractorName: json['contractorName'],
      status: TicketStatusExtension.fromString(json['status'] ?? 'NEW'),
      latitude: json['gps']?['latitude']?.toDouble() ??
          json['latitude']?.toDouble() ??
          0.0,
      longitude: json['gps']?['longitude']?.toDouble() ??
          json['longitude']?.toDouble() ??
          0.0,
      createdDate: json['createdAt'] != null || json['createdDate'] != null
          ? DateTime.parse(json['createdAt'] ?? json['createdDate'])
          : DateTime.now(),
      location: json['location'] ?? 'Unknown Location',
      priority: json['priority'] ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'beforePhoto': beforePhotoUrl,
      'afterPhoto': afterPhotoUrl,
      'contractorName': contractorName,
      'status': status.name,
      'gps': {
        'latitude': latitude,
        'longitude': longitude,
      }
    };
  }
}

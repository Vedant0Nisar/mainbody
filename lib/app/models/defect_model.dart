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
  final String inspectorName;
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
    this.inspectorName = 'Unknown Inspector',
    this.isNewlyAdded = false,
  });

  factory DefectModel.fromJson(Map<String, dynamic> json) {
    return DefectModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['defect_type'] ?? json['title'] ?? 'Defect Ticket',
      description: json['description'] ?? '',
      beforePhotoUrl: json['before_image'] ??
          json['beforePhotoUrl'] ??
          json['beforePhoto'] ??
          '',
      afterPhotoUrl:
          json['after_image'] ?? json['afterPhotoUrl'] ?? json['afterPhoto'],
      contractorName: json['contractor'],
      status: TicketStatusExtension.fromString(json['status'] ?? 'NEW'),
      latitude: json['latitude']?.toDouble() ??
          json['gps']?['latitude']?.toDouble() ??
          0.0,
      longitude: json['longitude']?.toDouble() ??
          json['gps']?['longitude']?.toDouble() ??
          0.0,
      createdDate: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.tryParse(json['created_at'] ?? json['createdAt']) ??
              DateTime.now()
          : DateTime.now(),
      location: json['location'] ?? 'Unknown Location',
      priority: json['severity'] ?? json['priority'] ?? 'Normal',
      inspectorName: json['createdBy'] ??
          json['inspector_name'] ??
          json['inspectorName'] ??
          'Unknown Inspector',
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

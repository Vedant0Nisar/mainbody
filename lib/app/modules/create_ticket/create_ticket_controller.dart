import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/defect_repository.dart';

class CreateTicketController extends GetxController {
  final DefectRepository _defectRepository;

  CreateTicketController(this._defectRepository);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString photoPath = ''.obs;
  final RxString gpsLocation = 'Latitude: 0.0, Longitude: 0.0'.obs;

  double lat = 0.0;
  double lng = 0.0;

  final RxBool isLoading = false.obs;

  void pickPhoto() async {
    // Mocking photo picker
    photoPath.value = 'dummy/path/to/photo.jpg';
    Get.snackbar('Photo', 'Photo attached successfully');
  }

  void getLocation() async {
    // Mocking GPS fetch
    lat = 12.9716;
    lng = 77.5946;
    gpsLocation.value = 'Lat: $lat, Lng: $lng';
    Get.snackbar('GPS', 'Location fetched successfully');
  }

  void submitTicket() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final success = await _defectRepository.createTicket(
        titleController.text,
        descriptionController.text,
        lat,
        lng,
        photoPath.value.isNotEmpty
            ? photoPath.value
            : 'https://images.unsplash.com/photo-1518152006812-edab29b069ac',
      );
      if (success) {
        Get.back(result: true); // Return true so Dashboard can refresh
        Get.snackbar('Success', 'Ticket created successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create ticket');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

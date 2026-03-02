import 'package:get/get.dart';
import '../../models/defect_model.dart';
import '../../models/status_enum.dart';
import '../../routes/app_routes.dart';
import '../../data/repositories/main_body_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/contractor_model.dart';

class DashboardController extends GetxController {
  final MainBodyRepository _apiRepository = MainBodyRepository();

  final RxList<DefectModel> defects = <DefectModel>[].obs;
  final RxMap<String, dynamic> stats = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;

  final Rx<TicketStatus?> selectedFilter = Rx<TicketStatus?>(null);

  List<DefectModel> get filteredRecentTickets {
    Iterable<DefectModel> filtered = defects;
    if (selectedFilter.value != null) {
      filtered = filtered.where((d) => d.status == selectedFilter.value);
    }
    var list = filtered.toList();
    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return list.take(10).toList();
  }

  void selectFilter(TicketStatus? status) {
    selectedFilter.value = status;
  }

  void showSuccessPopup(String message) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2E7D32),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final fetchedStats = await _apiRepository.getDashboardStats();
      stats.value = fetchedStats;

      final fetchedTickets = await _apiRepository.getTickets(limit: 100);
      defects.assignAll(
          fetchedTickets.map((e) => DefectModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int getCount(TicketStatus status) {
    if (stats.isEmpty) return 0;
    return stats[status.name.toLowerCase()] ?? 0;
  }

  void logout() async {
    final storage = GetStorage();
    await storage.remove('access_token');
    await storage.remove('isLoggedIn');
    await storage.remove('role');
    Get.offAllNamed(Routes.LOGIN);
  }

  void navigateToList(TicketStatus? filterStatus) {
    Get.toNamed(Routes.DEFECT_LIST, arguments: filterStatus);
  }

  Future<List<ContractorModel>> getContractors() async {
    try {
      final list = await _apiRepository.getContractors();
      return list
          .map((c) => ContractorModel(
                id: c['id'].toString(),
                name: c['name'],
                email: c['email'],
              ))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contractors',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      return [];
    }
  }

  Future<void> assignContractor(String ticketId, String contractorName) async {
    try {
      await _apiRepository.assignTicket(ticketId, contractorName);

      Get.snackbar('Success', 'Ticket Assigned Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);

      // Refresh the dashboard data to reflect the changes
      loadDashboardData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign contractor',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    }
  }
}

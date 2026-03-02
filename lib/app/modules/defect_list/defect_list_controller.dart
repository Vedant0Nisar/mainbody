import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/main_body_repository.dart';
import '../../models/defect_model.dart';
import '../../models/contractor_model.dart';
import '../../models/status_enum.dart';
import '../../routes/app_routes.dart';

class DefectListController extends GetxController {
  final MainBodyRepository _apiRepository = MainBodyRepository();

  final RxList<DefectModel> allDefects = <DefectModel>[].obs;
  final RxList<DefectModel> filteredDefects = <DefectModel>[].obs;

  final RxBool isLoading = true.obs;

  final Rx<TicketStatus?> selectedStatus = Rx<TicketStatus?>(null);

  int currentPage = 0;
  final int limit = 100;

  @override
  void onInit() {
    super.onInit();
    // Get arguments if passed from Dashboard (pre-filter by status)
    if (Get.arguments != null && Get.arguments is TicketStatus) {
      selectedStatus.value = Get.arguments as TicketStatus;
    }

    loadDefects();

    loadDefects();
  }

  Future<void> loadDefects() async {
    isLoading.value = true;
    try {
      final defects = await _apiRepository.getTickets(
          skip: currentPage * limit, limit: limit);
      allDefects
          .assignAll(defects.map((e) => DefectModel.fromJson(e)).toList());
      _applyFilters();
      Get.snackbar(
        'Success',
        'Tickets loaded successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load defects',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var tempList = allDefects.where((defect) {
      bool matchesStatus =
          selectedStatus.value == null || defect.status == selectedStatus.value;
      return matchesStatus;
    }).toList();

    // Simple mock pagination - just take all for now, in a real app would be paged
    filteredDefects.assignAll(tempList);
  }

  void setStatusFilter(TicketStatus? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  Future<void> assignContractor(String ticketId, String contractorName) async {
    try {
      final response =
          await _apiRepository.assignTicket(ticketId, contractorName);

      // Update local item
      final updatedDefect = DefectModel.fromJson(response);
      final index = allDefects.indexWhere((element) => element.id == ticketId);
      if (index != -1) {
        allDefects[index] = updatedDefect;
        _applyFilters();
      }

      Get.snackbar('Success', 'Ticket Assigned Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign contractor',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    }
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

  void navigateToDetail(DefectModel defect) {
    Get.toNamed(Routes.DEFECT_DETAIL, arguments: defect)?.then((_) {
      // Refresh when coming back in case status changed
      loadDefects();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}

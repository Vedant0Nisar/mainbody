import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/defect_repository.dart';
import '../../models/defect_model.dart';
import '../../models/status_enum.dart';
import '../../routes/app_routes.dart';

class DefectListController extends GetxController {
  final DefectRepository _defectRepository;

  DefectListController(this._defectRepository);

  final RxList<DefectModel> allDefects = <DefectModel>[].obs;
  final RxList<DefectModel> filteredDefects = <DefectModel>[].obs;

  final RxBool isLoading = true.obs;

  final Rx<TicketStatus?> selectedStatus = Rx<TicketStatus?>(null);
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Get arguments if passed from Dashboard (pre-filter by status)
    if (Get.arguments != null && Get.arguments is TicketStatus) {
      selectedStatus.value = Get.arguments as TicketStatus;
    }

    loadDefects();

    // Listen to search changes
    searchController.addListener(_applyFilters);
  }

  Future<void> loadDefects() async {
    isLoading.value = true;
    try {
      final defects = await _defectRepository.fetchDefects();
      allDefects.assignAll(defects);
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load defects');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();

    var tempList = allDefects.where((defect) {
      bool matchesStatus =
          selectedStatus.value == null || defect.status == selectedStatus.value;
      bool matchesSearch =
          query.isEmpty || defect.id.toLowerCase().contains(query);
      return matchesStatus && matchesSearch;
    }).toList();

    // Simple mock pagination - just take all for now, in a real app would be paged
    filteredDefects.assignAll(tempList);
  }

  void setStatusFilter(TicketStatus? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void navigateToDetail(DefectModel defect) {
    Get.toNamed(Routes.DEFECT_DETAIL, arguments: defect)?.then((_) {
      // Refresh when coming back in case status changed
      loadDefects();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

import 'package:get/get.dart';
import '../../data/repositories/defect_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/defect_model.dart';
import '../../models/status_enum.dart';
import '../../routes/app_routes.dart';

class DashboardController extends GetxController {
  final DefectRepository _defectRepository;
  final AuthRepository _authRepository;

  DashboardController(this._defectRepository, this._authRepository);

  final RxList<DefectModel> defects = <DefectModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final fetchedDefects = await _defectRepository.fetchDefects();
      defects.assignAll(fetchedDefects);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  int getCount(TicketStatus status) {
    return defects.where((d) => d.status == status).length;
  }

  void logout() async {
    await _authRepository.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  void navigateToList(TicketStatus? filterStatus) {
    Get.toNamed(Routes.DEFECT_LIST, arguments: filterStatus);
  }
}

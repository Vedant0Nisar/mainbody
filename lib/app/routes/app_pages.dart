import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';

// Import placeholders for other modules
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/defect_list/defect_list_binding.dart';
import '../modules/defect_list/defect_list_view.dart';
import '../modules/defect_detail/defect_detail_binding.dart';
import '../modules/defect_detail/defect_detail_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.DEFECT_LIST,
      page: () => const DefectListView(),
      binding: DefectListBinding(),
    ),
    GetPage(
      name: Routes.DEFECT_DETAIL,
      page: () => const DefectDetailView(),
      binding: DefectDetailBinding(),
    ),
  ];
}

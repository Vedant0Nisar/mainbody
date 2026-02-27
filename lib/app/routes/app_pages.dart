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
import '../modules/create_ticket/create_ticket_binding.dart';
import '../modules/create_ticket/create_ticket_view.dart';
import '../modules/profile/profile_view.dart';
import '../modules/settings/settings_view.dart';
import '../modules/help/help_view.dart';

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
    GetPage(
      name: Routes.CREATE_TICKET,
      page: () => const CreateTicketView(),
      binding: CreateTicketBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.HELP,
      page: () => const HelpView(),
      transition: Transition.noTransition,
    ),
  ];
}

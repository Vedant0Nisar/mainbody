import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/layout_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;

  MainLayout({Key? key, required this.title, required this.body})
      : super(key: key) {
    if (!Get.isRegistered<LayoutController>()) {
      Get.put(LayoutController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return Scaffold(
            appBar: _buildAppBar(context, isMobile: true),
            drawer: _buildDrawer(context),
            body: body,
          );
        }

        return Scaffold(
          body: Row(
            children: [
              _buildSidePanel(context),
              Expanded(
                child: Column(
                  children: [
                    _buildAppBar(context, isMobile: false),
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context,
      {required bool isMobile}) {
    final themeInfo = Theme.of(context);
    return AppBar(
      title: Text(
        'Main Body Portal',
        style: TextStyle(
          color: themeInfo.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: !isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Get.find<LayoutController>().toggleSidebar(),
            )
          : null, // Scaffold handles hamburger
      actions: [
        _buildNotificationBell(context),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNotificationBell(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Stack(
        children: [
          const Icon(Icons.notifications_none_outlined, size: 28),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: const Text(
                '3',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: '1',
          child: Text('New ticket #1024 assigned'),
        ),
        const PopupMenuItem(
          value: '2',
          child: Text('Contractor verified ticket #1020'),
        ),
        const PopupMenuItem(
          value: '3',
          child: Text('System update scheduled'),
        ),
      ],
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: _sidePanelContent(context, isExpanded: true),
    );
  }

  Widget _buildSidePanel(BuildContext context) {
    final controller = Get.find<LayoutController>();
    return Obx(() {
      final isExpanded = controller.isSidebarExpanded.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isExpanded ? 240 : 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border:
              Border(right: BorderSide(color: Colors.grey.withOpacity(0.2))),
        ),
        child: _sidePanelContent(context, isExpanded: isExpanded),
      );
    });
  }

  Widget _sidePanelContent(BuildContext context, {required bool isExpanded}) {
    final currentRoute = Get.currentRoute;
    final themeController = Get.find<ThemeController>();

    return Column(
      children: [
        const SizedBox(height: 32),
        // Header
        if (isExpanded)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF0D6EFD),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin User',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('admin@portal.com',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          const CircleAvatar(
            backgroundColor: Color(0xFF0D6EFD),
            child: Icon(Icons.person, color: Colors.white),
          ),
        const SizedBox(height: 32),

        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildMenuItem(context, Icons.dashboard_outlined, 'Dashboard',
                  Routes.DASHBOARD, currentRoute, isExpanded),
              _buildMenuItem(context, Icons.person_outline, 'Profile',
                  Routes.PROFILE, currentRoute, isExpanded),
              _buildMenuItem(context, Icons.settings_outlined, 'Settings',
                  Routes.SETTINGS, currentRoute, isExpanded),
              _buildMenuItem(context, Icons.help_outline, 'Help', Routes.HELP,
                  currentRoute, isExpanded),
            ],
          ),
        ),

        // Footer items
        const Divider(),
        Obx(() => _buildActionItem(
              context,
              themeController.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode_outlined,
              'Theme',
              themeController.toggleTheme,
              isExpanded,
            )),
        _buildActionItem(context, Icons.logout, 'Logout', () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('isLoggedIn');
          await prefs.remove('role');
          Get.offAllNamed(Routes.LOGIN);
        }, isExpanded),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      String route, String currentRoute, bool isExpanded) {
    final isSelected = currentRoute == route;
    final primaryColor = const Color(0xFF0D6EFD);
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (!isSelected) {
          Get.toNamed(route);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment:
              isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? primaryColor : theme.iconTheme.color,
                size: 24),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? primaryColor
                      : theme.textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title,
      VoidCallback onTap, bool isExpanded) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment:
              isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.iconTheme.color, size: 24),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Text(title,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
            ],
          ],
        ),
      ),
    );
  }
}

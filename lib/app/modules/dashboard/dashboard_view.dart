import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../models/status_enum.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Ticket Overview',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                      context,
                      'New Tickets',
                      controller.getCount(TicketStatus.newTicket),
                      Colors.orange,
                      TicketStatus.newTicket),
                  _buildStatCard(
                      context,
                      'Assigned',
                      controller.getCount(TicketStatus.assigned),
                      Colors.blue,
                      TicketStatus.assigned),
                  _buildStatCard(
                      context,
                      'Repaired',
                      controller.getCount(TicketStatus.repaired),
                      Colors.purple,
                      TicketStatus.repaired),
                  _buildStatCard(
                      context,
                      'Rework',
                      controller.getCount(TicketStatus.rework),
                      Colors.red,
                      TicketStatus.rework),
                  _buildStatCard(
                      context,
                      'Closed',
                      controller.getCount(TicketStatus.closed),
                      Colors.green,
                      TicketStatus.closed),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => controller.navigateToList(null),
                icon: const Icon(Icons.list),
                label: const Text('View All Tickets'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count,
      Color color, TicketStatus status) {
    return InkWell(
      onTap: () => controller.navigateToList(status),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

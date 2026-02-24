import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'defect_list_controller.dart';
import '../../models/status_enum.dart';
import 'package:intl/intl.dart';

class DefectListView extends GetView<DefectListController> {
  const DefectListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defects'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Ticket ID...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(null, 'All'),
                      _buildFilterChip(TicketStatus.newTicket, 'New'),
                      _buildFilterChip(TicketStatus.assigned, 'Assigned'),
                      _buildFilterChip(TicketStatus.repaired, 'Repaired'),
                      _buildFilterChip(TicketStatus.rework, 'Rework'),
                      _buildFilterChip(TicketStatus.closed, 'Closed'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredDefects.isEmpty) {
          return const Center(child: Text('No tickets found.'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadDefects,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredDefects.length,
            itemBuilder: (context, index) {
              final defect = controller.filteredDefects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(defect.id,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      _buildStatusBadge(context, defect.status),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(defect.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(DateFormat('MMM dd, yyyy - HH:mm')
                              .format(defect.createdDate)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: defect.priority == 'High'
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Priority: ${defect.priority}',
                            style: TextStyle(
                              color: defect.priority == 'High'
                                  ? Colors.red
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                  onTap: () => controller.navigateToDetail(defect),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildFilterChip(TicketStatus? status, String label) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            controller.setStatusFilter(selected ? status : null);
          },
        ),
      );
    });
  }

  Widget _buildStatusBadge(BuildContext context, TicketStatus status) {
    Color color;
    switch (status) {
      case TicketStatus.newTicket:
        color = Colors.orange;
        break;
      case TicketStatus.assigned:
        color = Colors.blue;
        break;
      case TicketStatus.repaired:
        color = Colors.purple;
        break;
      case TicketStatus.rework:
        color = Colors.red;
        break;
      case TicketStatus.closed:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status.name,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

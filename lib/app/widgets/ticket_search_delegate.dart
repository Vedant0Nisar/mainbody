import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/defect_model.dart';
import '../models/status_enum.dart';
import '../modules/defect_list/defect_list_controller.dart';

class TicketSearchDelegate extends SearchDelegate<DefectModel?> {
  final DefectListController controller = Get.find<DefectListController>();

  @override
  String get searchFieldLabel => 'Search by Location, Inspector, or Contractor';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final lowerQuery = query.toLowerCase();

    final results = controller.allDefects.where((ticket) {
      final matchContractor =
          (ticket.contractorName ?? '').toLowerCase().contains(lowerQuery);
      final matchInspector =
          ticket.inspectorName.toLowerCase().contains(lowerQuery);
      final matchLocation = ticket.location.toLowerCase().contains(lowerQuery);

      return matchContractor || matchInspector || matchLocation;
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tickets found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final defect = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(defect.id,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
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
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text('Inspector: ${defect.inspectorName}',
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                if (defect.contractorName != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.engineering_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text('Contractor: ${defect.contractorName}',
                              maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
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
              ],
            ),
            onTap: () {
              close(context, null);
              controller.navigateToDetail(defect);
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, TicketStatus status) {
    Color color;
    switch (status) {
      case TicketStatus.newTicket:
        color = Colors.blue;
        break;
      case TicketStatus.assigned:
        color = Colors.purple;
        break;
      case TicketStatus.repaired:
        color = Colors.orange;
        break;
      case TicketStatus.verified:
        color = Colors.teal;
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

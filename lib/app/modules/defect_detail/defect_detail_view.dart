import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'defect_detail_controller.dart';
import '../../models/status_enum.dart';

class DefectDetailView extends GetView<DefectDetailController> {
  const DefectDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defect Details'),
      ),
      body: Obx(() {
        if (!controller.rxIsInit.value)
          return const SizedBox.shrink(); // Prevent error before init
        final defect = controller.defect.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, defect),
              const SizedBox(height: 16),
              _buildPhotoSection(context, defect),
              const SizedBox(height: 16),
              _buildInfoSection(context, defect),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, defect) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          defect.id,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        _buildStatusBadge(context, defect.status),
      ],
    );
  }

  Widget _buildPhotoSection(BuildContext context, defect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Before Repair',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: defect.beforePhotoUrl,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[200],
              child:
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
        ),
        if (defect.afterPhotoUrl != null) ...[
          const SizedBox(height: 16),
          Text('After Repair',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: defect.afterPhotoUrl!,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image,
                    size: 50, color: Colors.grey),
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, defect) {
    return Card(
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withOpacity(0.3),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withOpacity(0.2))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.description, 'Description', defect.description),
            const Divider(),
            _buildInfoRow(Icons.location_on, 'Location', defect.location),
            const Divider(),
            _buildInfoRow(Icons.map, 'GPS Coordinates',
                '${defect.latitude.toStringAsFixed(4)}, ${defect.longitude.toStringAsFixed(4)}'),
            const Divider(),
            _buildInfoRow(Icons.warning, 'Priority', defect.priority,
                isPriority: true),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Reported On',
                DateFormat('MMM dd, yyyy - HH:mm').format(defect.createdDate)),
            const Divider(),
            _buildInfoRow(Icons.title, 'Title', defect.title),
            if (defect.contractorName != null) ...[
              const Divider(),
              _buildInfoRow(Icons.engineering, 'Assigned Contractor',
                  defect.contractorName!),
            ],
            const Divider(),
            _buildInfoRow(Icons.person, 'Inspector', defect.inspectorName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isPriority = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isPriority && value == 'High'
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: isPriority && value == 'High' ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        status.name,
        style:
            TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}

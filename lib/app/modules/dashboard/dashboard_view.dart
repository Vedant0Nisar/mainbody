import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'widgets/ticket_search_delegate.dart';
import '../../models/status_enum.dart';
import '../../models/defect_model.dart';
import '../../widgets/main_layout.dart';
import '../../models/contractor_model.dart';
import '../../widgets/assign_dialog.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: TicketSearchDelegate(controller.defects),
            );
          },
        ),
      ],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: LayoutBuilder(builder: (context, constraints) {
                  final cardWidth =
                      (constraints.maxWidth - 12) / 2; // 2 columns
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Recent Tickets',
                          controller.defects.length.toString(),
                          Colors.blue[700]!,
                          null,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'New Tickets',
                          controller
                              .getCount(TicketStatus.newTicket)
                              .toString(),
                          Colors.blue,
                          TicketStatus.newTicket,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Assigned',
                          controller.getCount(TicketStatus.assigned).toString(),
                          Colors.purple,
                          TicketStatus.assigned,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Repaired',
                          controller.getCount(TicketStatus.repaired).toString(),
                          Colors.orange,
                          TicketStatus.repaired,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Rework',
                          controller.getCount(TicketStatus.rework).toString(),
                          Colors.red,
                          TicketStatus.rework,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Closed',
                          controller.getCount(TicketStatus.closed).toString(),
                          Colors.green,
                          TicketStatus.closed,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              // List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Inspector Tickets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '${controller.filteredRecentTickets.length} records',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // List View
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<String>(
                        controller.selectedFilter.value?.name ?? 'all'),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: controller.filteredRecentTickets.length,
                    itemBuilder: (context, index) {
                      return _buildInspectionCard(
                          context, controller.filteredRecentTickets[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color countColor, TicketStatus? status) {
    return Builder(builder: (context) {
      final isSelected = controller.selectedFilter.value == status;
      return InkWell(
        onTap: () => controller.selectFilter(status),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? countColor.withOpacity(0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isSelected ? countColor : countColor.withOpacity(0.4),
                width: isSelected ? 2.5 : 1.5),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? countColor.withOpacity(0.2)
                    : Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: countColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInspectionCard(BuildContext context, DefectModel defect) {
    return BlinkingBorderCard(
      isBlinking: defect.isNewlyAdded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Defect Type & 6. Ticket Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  defect.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(defect.status),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Defect Description
          Text(
            defect.description.isNotEmpty
                ? defect.description
                : 'No description provided.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Severity
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                'Severity: ${defect.priority}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 4. Pin Point Exact Location
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on,
                    size: 20, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lat: ${defect.latitude.toStringAsFixed(6)} | Lng: ${defect.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        defect.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. Uploaded Image
          if (defect.beforePhotoUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                defect.beforePhotoUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 7. Assigned Contractor & 8. Created Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.engineering,
                        size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        defect.contractorName?.isNotEmpty == true
                            ? defect.contractorName!
                            : 'Unassigned',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${defect.createdDate.day}/${defect.createdDate.month}/${defect.createdDate.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed('/defect-detail', arguments: defect);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: const Color(0xFF555555),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Details',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _showAssignDialog(context, defect),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF0D6EFD), // Bright Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Assign Ticket',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TicketStatus status) {
    Color badgeColor;
    switch (status) {
      case TicketStatus.newTicket:
        badgeColor = Colors.blue;
        break;
      case TicketStatus.assigned:
        badgeColor = Colors.purple;
        break;
      case TicketStatus.repaired:
        badgeColor = Colors.orange;
        break;
      case TicketStatus.verified:
        badgeColor = Colors.teal;
        break;
      case TicketStatus.rework:
        badgeColor = Colors.red;
        break;
      case TicketStatus.closed:
        badgeColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isSelected,
      {VoidCallback? onTap}) {
    return Builder(builder: (context) {
      final color = isSelected
          ? const Color(0xFF0D6EFD)
          : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[500];
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showAssignDialog(BuildContext context, defect) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final contractors = await controller.getContractors();
      Get.back(); // close loader

      final result = await showModalBottomSheet<ContractorModel>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AssignDialog(
          ticket: defect,
          contractors: contractors,
        ),
      );

      if (result != null) {
        controller.assignContractor(defect.id, result.name);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to prepare assignment',
          snackPosition: SnackPosition.TOP);
    }
  }
}

class BlinkingBorderCard extends StatefulWidget {
  final Widget child;
  final bool isBlinking;

  const BlinkingBorderCard(
      {Key? key, required this.child, this.isBlinking = false})
      : super(key: key);

  @override
  _BlinkingBorderCardState createState() => _BlinkingBorderCardState();
}

class _BlinkingBorderCardState extends State<BlinkingBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Colors.red.withOpacity(0.1),
      end: Colors.red.withOpacity(1.0), // Pulses to strong red
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isBlinking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BlinkingBorderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && !oldWidget.isBlinking) {
      _controller.repeat(reverse: true);
    } else if (!widget.isBlinking && oldWidget.isBlinking) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isBlinking
                  ? (_colorAnimation.value ?? Colors.transparent)
                  : Colors.red
                      .withOpacity(0.4), // Default highlight when not blinking
              width:
                  widget.isBlinking ? 3.0 : 2.0, // Make blinking border broader
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
